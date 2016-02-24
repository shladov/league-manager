class ChargesController < ApplicationController
  def new
    if current_user
      @pl = PreLeague.find(current_user.pre_league_id)
      @amount  = (@pl.max_teams * @pl.max_players_per_team)
    end
  end

  def create
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    pl = PreLeague.find(current_user.pre_league_id)
    # Get the credit card details submitted by the form
    token = params[:stripeToken]
    league = pl["league_name"]
    @amount  = (pl[:max_teams] * pl[:max_players_per_team])
    @amount_in_cents = @amount * 100
    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      customer = Stripe::Customer.create(
        :source => token,
        :description => current_user.email
      )

      charge = Stripe::Charge.create(
        :amount => @amount_in_cents,
        :currency => "usd",
        :customer => customer.id,
        :description => "Charge for #{league} league."
      )
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end


    # build league if card goes through
    League.create(
      :name => pl["league_name"],
      :subdomain => pl["subdomain"],
      :url => pl["subdomain"] + ".leaguehero.io",
      :max_teams => pl["max_teams"],
      :max_players_per_team => pl["max_players_per_team"],
      :admin_name => current_user.name,
      :admin_email => current_user.email
    )
    # update current_user with subdomain
    user = User.find_by_email(current_user.email)
    user.subdomain = pl["subdomain"]
    # add stripe id to user 
    user.stripe_id = customer.id
    user.save!
    # use this route so user can'tD refresh confirmation page and send another call to Stripe
    redirect_to "/charges/confirmation"
  end

# all functionality in this route should be moved to the league controller.
  def confirmation
    # find League from current_user
    @league = League.find_by_subdomain(current_user["subdomain"])
  end
end

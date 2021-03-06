# We won't need this until we add premium accounts, even then- might not need subscriptions
# Use this as reference


# class SubscriptionsController < ApplicationController
#   before_action :authenticate_user!
#   def index
#     @account = Account.find_by_email(current_user.email)
#   end
#
#   def new
#     @plans = Plan.all
#   end
#
#   def edit
#     @account = Account.find(params[:id])
#     @plans   = Plan.all
#   end
#
#   def create
#     # Get the credit card details submitted by the form
#     token           = params[:stripeToken]
#     plan            = params[:plan][:stripe_id]
#     email           = current_user.email
#     current_account = Account.find_by_email(current_user.email)
#     customer_id     = current_account.customer_id
#     current_plan    = current_account.stripe_plan_id
#
#     # Check if we need to create a new Stripe customer
#     if customer_id.nil?
#       # New customer
#       # Create a Customer
#       @customer = Stripe::Customer.create(
#         :source => token,
#         :plan => plan,
#         :email => email
#       )
#       subscriptions = @customer.subscriptions
#       @subscribed_plan = subscriptions.data.find {|o| o.plan.id == plan }
#     else
#       # get customer from Stripe
#       @customer        = Stripe::Customer.retrieve(customer_id)
#       @subscribed_plan = create_or_update_subscription(@customer, current_plan, plan)
#     end
#
#     # get active_until from subscribed plan
#     current_period_end = @subscribed_plan.current_period_end
#     # need to convert to rails timestamp
#     active_until = Time.at(current_period_end).to_datetime
#
#     save_account_details(current_account, plan, @customer.id, active_until)
#
#     redirect_to :root, :notice => "Successfully subscribed to a plan!"
#
#   rescue => e
#     redirect_to :back, :flash => {:error => e.message}
#   end
#
#   def cancel_subscription
#     email           = current_user.email
#     current_account = Account.find_by_email(current_user.email)
#     customer_id     = current_account.customer_id
#     current_plan    = current_account.stripe_plan_id
#
#     if current_plan.blank?
#       raise "No plan found to unsubscribe"
#     end
#     # fetch customer from stripe
#     customer = Stripe::Customer.retrieve(customer_id)
#
#     # get subscriptions
#     subscriptions = customer.subscriptions
#
#     # find subscription to cancel
#     current_subscribed_plan = subscriptions.data.find {|o| o.plan.id == current_plan }
#
#     if current_subscribed_plan.blank?
#       raise "Subscription not found"
#     end
#     # delete it
#     current_subscribed_plan.delete
#     # update account
#     save_account_details(current_account, "",customer_id, Time.at(0).to_datetime)
#
#     @message = "Subscription was removed successfully"
#
#   rescue => e
#     redirect_to "/subscriptions", :flash => {:error => e.message}
#   end
#
#   def update_card
#
#   end
#
#   def update_card_details
#     # use token that is given to us by Stripe
#     token = params[:stripeToken]
#     # get customer id
#     current_account = Account.find_by_email(current_user.email)
#     customer_id     = current_account.customer_id
#     # get customer from Stripe
#     customer = Stripe::Customer.retrieve(customer_id)
#     # set new card token
#     customer.source = token
#     customer.save
#
#     redirect_to "/subscriptions", :notice => "Card was updated successfully"
#
#   rescue => e
#     redirect_to :action => "update_card", :flash => {:error => e.message}
#
#   end
#
#   def save_account_details(account, plan, customer_id, active_until)
#     # Update account with the details
#     account.stripe_plan_id = plan
#     account.customer_id    = customer_id
#     account.active_until   = active_until
#     account.save!
#   end
#
#   def create_or_update_subscription(customer, current_plan, new_plan)
#       subscriptions        = customer.subscriptions
#       current_subscription = subscriptions.data.find {|o| o.plan.id == current_plan }
#
#       if current_subscription.blank?
#         # No subscriptions, create new one to existing customer
#         subscription = customer.subscriptions.create({:plan => new_plan})
#       else
#         # customer has subscription
#         current_subscription.plan = new_plan
#         subscription = current_subscription.save
#       end
#       return subscription
#   end
#
# end

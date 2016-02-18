class PagesController < ApplicationController
  include PagesHelper

  def show
    if !request.subdomain.blank?
      create_rankings
      @posts = Post.all
      if @posts.blank?
        Post.create(
        title: "Welcome to League Hero",
        body: "Congrats on joining the the fastest, simplest way to set up and manage any sports league! If you have any questions or comments along the way, feel free to reach out to your league admin or getleaguehero@gmail.com.
        Game On!"
        )
      end
      # Apartment::Tenant.switch!(request.subdomain)
    end
    if valid_page?
      render template: "pages/#{params[:page]}"
    else
      render file: "public/404.html", status: :not_found
    end
  end

  private
  def valid_page?
    File.exist?(Pathname.new(Rails.root + "app/views/pages/#{params[:page]}.html.erb"))
  end

end

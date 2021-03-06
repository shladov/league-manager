require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  describe 'sends user to ' do

    it 'sign up page when not on subdomain' do
      get :new

      expect(response).to_not be_redirect
    end

    it 'root page if on subdomain' do
      controller.request.host = 'sub.domain.com'
      get :new

      expect(response).to be_redirect
    end
  end


  controller do
    def after_sign_up_path_for(resource)
      super resource
    end
  end

  describe 'user signs up ' do

    it " and current_user is set" do

      post :create, user: FactoryGirl.attributes_for(:user)
      expect( subject.current_user ).not_to be nil
    end

    it " and current_user is not set since params are not correct" do

      post :create, user: FactoryGirl.attributes_for(:bad_user)
      expect( subject.current_user ).to be nil
    end

  end
end

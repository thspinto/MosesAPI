require 'spec_helper'

describe Api::V1::UsersController do
  describe "GET #show" do

    context "when successfully gets a user" do
      before(:each) do
        @user = FactoryGirl.create :user
        get :show, id: @user.id
      end

      it "returns the user information" do
        user_response = json_response
        expect(user_response[:email]).to eql @user.email
        expect(user_response[:first_name]).to eql @user.first_name
        expect(user_response[:full_name]).to eql @user.full_name
        expect(user_response[:facebook_id]).to eql @user.facebook_id
        expect(user_response[:timezone]).to eql @user.timezone
        expect(user_response[:locale]).to eql @user.locale
      end

      it { should respond_with 200 }
    end

    context "when user does not exist" do
      before(:each) do
        get :show, id: 111
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the group could not be shown" do
        user_response = json_response
        expect(user_response[:errors]).to include "user not found"
      end

      it { should respond_with 422 }
    end

  end

  describe "PUT/PATCH #update" do

    context "when is successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        @new_user = { email: "new@email.com",
                              first_name: "New", full_name: "New Name",
                              facebook_id: "12011022", locale: 'pt_BR',
                              timezone: 2 }
        patch :update, { id: @user.id, user: @new_user }
      end

      it "renders the json representation for the updated user" do
        user_response = json_response
        expect(user_response[:email]).to eql @new_user[:email]
        expect(user_response[:first_name]).to eql @new_user[:first_name]
        expect(user_response[:full_name]).to eql @new_user[:full_name]
        expect(user_response[:facebook_id]).to eql @new_user[:facebook_id]
        expect(user_response[:locale]).to eql @new_user[:locale]
        expect(user_response[:timezone]).to eql @new_user[:timezone]

      end

      it { should respond_with 200 }
    end

    context "when has invalid email" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id,
                        user: { email: "email.com"} }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors][:email]).to include "is invalid"
      end

      it { should respond_with 422 }
    end

    context "when user does no exist" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: 111,
                        user: { email: "email.com"} }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be created" do
        user_response = json_response
        expect(user_response[:errors]).to include "user not found"
      end

      it { should respond_with 422 }
    end
  end

  describe "DELETE #destroy" do
    context "when user exists" do
      before(:each) do
        @user = FactoryGirl.create :user
        delete :destroy, { id: @user.id }
      end

      it { should respond_with 204 }
    end

    context "when user doesn't exist" do
      before(:each) do
        delete :destroy, { id: 111 }
      end

      it "renders an errors json" do
        user_response = json_response
        expect(user_response).to have_key(:errors)
      end

      it "renders the json errors on why the user could not be destroyed" do
        user_response = json_response
        expect(user_response[:errors]).to include "user not found"
      end

      it { should respond_with 422 }
    end
  end
end

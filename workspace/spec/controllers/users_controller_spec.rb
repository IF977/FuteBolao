require 'spec_helper'

describe UsersController do

  before :each do
    @user_session = create(:user)
    sign_in @user_session
  end

  describe 'GET profile' do
    it "assigns the requested user profile to @profile" do
      profile = create(:user)
      get :profile, id: profile.id
      assigns(:profile).should eq(profile.decorate)
    end
  end

  describe 'GET history' do
    it "assigns the current user in session to @history" do
      get :history
      assigns(:history).should eq(@user_session.decorate)
    end
  end

end
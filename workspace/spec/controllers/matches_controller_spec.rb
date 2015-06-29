require 'spec_helper'

describe MatchesController do

  before :each do
    @user_session = create(:user)
    sign_in @user_session
  end

  describe 'GET show' do
    it "assigns the requested match profile to @match" do
      match = create(:match)
      get :show, id: match.id
      assigns(:match).should eq(match.decorate)
    end
  end

end
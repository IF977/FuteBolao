require 'spec_helper'

describe DashboardController do

  describe 'GET index' do

    it 'sould redirect if not logged in' do
      get :index
      response.should redirect_to new_user_session_path
    end

    it 'only matches from active groups grouped by group' do
      user = create(:user)
      sign_in user
      
      group_a = create(:group)
      group_b = create(:group, active: false)

      match_a = create(:match, group: group_a)
      match_b = create(:match, group: group_b)
      
      active_matches_by_group = Match.active.decorate(context: {user: user}).group_by(&:group)

      get :index
      assigns(:grouped_matches).should include(active_matches_by_group)
      assigns(:grouped_matches).should_not include(match_b)
    end

  end
end
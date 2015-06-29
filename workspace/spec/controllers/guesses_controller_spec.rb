require 'spec_helper'

describe GuessesController do

  before :each do
    @user_session = create(:user)
    sign_in @user_session
  end

  describe 'GET my guesses' do

    it 'sould redirect if not logged in' do
      create(:guess, match: create(:match), user: @user_session)
      create(:guess, match: create(:match), user: @user_session)
      create(:guess, match: create(:match), user: @user_session)

      my_matches_and_guesses_grouped = Match.open_to_guesses.decorate(context: {user: @user_session}).group_by(&:group)

      get :my_guesses
      assigns(:grouped_matches).should eq(my_matches_and_guesses_grouped)
    end

  end

  describe 'POST update' do

    it 'should update/create the guesses for the current user' do
      guess = create(:guess, match: create(:future_match), user: @user_session, goals_a: 3, goals_b: 1)
      match = create(:past_match)

      guesses_post = {guesses:
                        [ 
                           {id: guess.id, match_id: guess.match.id, goals_a: '1', goals_b: '2'},
                           {id: '', match_id: match.id, goals_a: '3', goals_b: '4'}
                        ]
                     }

      post :update, guesses: guesses_post[:guesses]
      
      # verify guesses where create/update for future match
      guess.reload
      guess.goals_a.should == 1
      guess.goals_b.should == 2


      # verify no guesses where created for past matches
      match.reload
      match.guesses.should be_empty
    end

    it 'should create only one guess for match by user' do
      match = create(:future_match)

      guesses_post = {guesses:
                        [ 
                           {id: '', match_id: match.id, goals_a: '1', goals_b: '2'},
                           {id: '', match_id: match.id, goals_a: '1', goals_b: '2'}
                        ]
                     }

      post :update, guesses: guesses_post[:guesses]
      @user_session.guesses.select { |g| g.match_id == match.id }.size.should == 1
    end

    it 'redirects to my guesses after update' do
      match = create(:past_match)
      guesses_post = {guesses: [ { id: '', match_id: match.id, goals_a: '', goals_b: ''} ] }
      post :update, guesses: guesses_post[:guesses]
      response.should redirect_to my_guesses_path
    end

  end
end
require 'spec_helper'

describe Bolao::Guesses do

  it 'should save the user guesses only for open matches' do
    user = create(:user)
    future_match = create(:future_match)
    past_match   = create(:past_match)

    guesses_post = {guesses: 
                      [ 
                         {match_id: future_match.id, id: '', goals_a: '1', goals_b: '1'},
                         {match_id: past_match.id, id: '', goals_a: '3', goals_b: '4'}
                      ]
                   }

    Bolao::Guesses.save(guesses_post, user)

    guesses = Guess.where(user: user)
    guesses.size.should   == 1
    guesses.first.goals_a.should == 1
    guesses.first.goals_b.should == 1
    guesses.first.match.should   == future_match
  end

  it 'should update the user guesses if they exists (and are open for guesses)' do
    user = create(:user)
    future_match = create(:future_match)

    guesses_post = {guesses: [ {match_id: future_match.id, id: '', goals_a: '1', goals_b: '1'} ] }
    Bolao::Guesses.save(guesses_post, user)
    
    guess = Guess.where(user: user).first
    guesses_post = {guesses: [ {match_id: future_match.id, id: guess.id.to_s, goals_a: '3', goals_b: '7'} ] }

    Bolao::Guesses.save(guesses_post, user)
    guesses = Guess.where(user: user)
    guesses.size.should == 1
    guesses.first.id.should == guess.id
    guesses.first.goals_a.should == 3
    guesses.first.goals_b.should == 7
  end

end
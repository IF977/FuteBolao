require 'spec_helper'

describe Guess do

  context 'model attributes validations' do

    let!(:guess) { build(:guess) }
    subject { guess }

    it 'should belong to a user' do
      guess.user = nil
      guess.should_not be_valid
    end

    it 'should belong to a match' do
      guess.match = nil
      guess.should_not be_valid
    end

    it 'should have goals for team a' do
      guess.goals_a = nil
      guess.should_not be_valid
    end

    it 'should have goals for team b' do
      guess.goals_b = nil
      guess.should_not be_valid
    end

    it "should return the result in to_s" do
      guess.to_s.should == "#{guess.goals_a} x #{guess.goals_b}"
    end

    it "should accept only one guess for match by user" do
      guess.save
      guess_2 = build(:guess, user: guess.user, match: guess.match)
      guess_2.should_not be_valid
    end

  end

  context 'scopes' do

    it 'should list guesses only for finished matches' do
      future = create(:guess, match: build(:future_match))
      create(:guess, match: build(:past_match))
      create(:guess, match: build(:past_match))

      finished = Guess.finished
      finished.should have_at_least(2).guesses
      finished.should_not include(future)
    end

  end

  context 'class methods' do

    it 'should have a winner' do
      guess = build(:guess, goals_a: 2, goals_b: 1)
      guess.winner.should == :team_a

      guess.update_attributes(goals_a: 1, goals_b: 2)
      guess.winner.should == :team_b

      guess.update_attributes(goals_a: 1, goals_b: 1)
      guess.winner.should == :draw
    end

    it 'should return score 0 for unfinished matches' do
      guess = create(:guess, match: build(:future_match))
      guess.score.should == 0
    end

    it 'should return score 0 for guesses that dont match the result' do
      guess = create(:guess, goals_a: 1, goals_b: 1, match: build(:past_match, goals_a: 2, goals_b: 1))
      guess.score.should == 0
    end

    it 'should return score 1 if the guesses matches the winnner or if its a draw, but not the final result' do
      # winner
      guess = create(:guess, goals_a: 3, goals_b: 1, match: build(:past_match, goals_a: 2, goals_b: 1))
      guess.score.should == 1

      # draw
      guess = create(:guess, goals_a: 1, goals_b: 1, match: build(:past_match, goals_a: 2, goals_b: 2))
      guess.score.should == 1
    end

    it 'should return score 3 if the guess matches the final result' do
      guess = create(:guess, goals_a: 1, goals_b: 3, match: build(:past_match, goals_a: 1, goals_b: 3))
      guess.score.should == 3
    end
  end
end
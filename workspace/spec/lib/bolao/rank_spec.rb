require 'spec_helper'

describe Bolao::Rank do

  it 'should update the user score' do
    user    = create(:user)
    match_1 = build(:match, goals_a: 1, goals_b: 1)
    match_2 = build(:match, goals_a: 2, goals_b: 1)
    match_3 = build(:match, goals_a: 2, goals_b: 3)
    create(:guess, match: match_1, user: user, goals_a: 1, goals_b: 1) # 3
    create(:guess, match: match_2, user: user, goals_a: 3, goals_b: 1) # 1
    create(:guess, match: match_3, user: user, goals_a: 3, goals_b: 3) # 0

    Bolao::Rank.update_scores User.all

    user.reload
    user.score.should == 4
  end

  context 'rank positions' do

    before(:all) do
      @users = [ 
        user_a = create(:user, score: 10),
        user_b = create(:user, score: 9),
        user_c = create(:user, score: 9),
        user_d = create(:user, score: 7),
        user_e = create(:user, score: 1) 
      ]
    end

    it 'should return the positions for de users ordered by score' do
      Bolao::Rank.positions(@users).should == [1,2,2,4,5]
    end

    it 'should update rank the users rank position' do
      Bolao::Rank.update_rank @users
      @users.each { |u| u.reload }
      @users[0].position.should == 1
      @users[1].position.should == 2
      @users[2].position.should == 2
      @users[3].position.should == 4
      @users[4].position.should == 5
    end

  end
end
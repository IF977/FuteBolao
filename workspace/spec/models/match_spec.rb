require 'spec_helper'

describe Match do

  context 'model attributes validations' do
   
    let!(:match) { build(:match) }
    subject { match }

    it { should be_valid }

    it 'should have a datetime' do
      match.datetime = nil
      match.should_not be_valid
    end

    it 'should have a team a' do
      match.team_a = nil
      match.should_not be_valid
    end

    it 'should have a team b' do
      match.team_b = nil
      match.should_not be_valid
    end

    it 'should belong to a group' do
      match.group = nil
      match.should_not be_valid
    end

  end

  context 'scopes' do
    it 'should list matchs from active groups' do
      group_a = create(:group)
      group_b = create(:group, active: false)
      create(:match, group: group_a)
      match_b = create(:match, group: group_b)
      Match.active.should_not include(match_b)
    end

    it 'should list only matches open to guesses' do
      match_future = create(:future_match)
      match_past = create(:past_match)
      Match.open_to_guesses.should     include(match_future)
      Match.open_to_guesses.should_not include(match_past)
    end

    it 'should list matches ordered by group name' do
      m1 = create(:future_match, group: create(:group, name: 'E'))
      m2 = create(:future_match, group: create(:group, name: 'C'))
      m3 = create(:future_match, group: create(:group, name: 'B'))
      m4 = create(:future_match, group: create(:group, name: 'A'))

      matches = Match.where(id: [m1, m2, m3, m4]).group_ordered
      
      matches[0].group.name.should == 'A'
      matches[1].group.name.should == 'B'
      matches[2].group.name.should == 'C'
      matches[3].group.name.should == 'E'
    end

    it 'should list matches for today' do
      m1 = create(:future_match, datetime: Time.now)
      m2 = create(:future_match, datetime: Time.now)
      m3 = create(:future_match)

      matches = Match.today
      matches.should include(m1,m2)
      matches.should_not include(m3)
    end
  end

  context 'class methods' do
    it 'check if match is finished' do
      match = build(:match)
      match.finished?.should be_false
      match.update_attributes(goals_a: 1, goals_b: 1)
      match.finished?.should be_true
    end

    it 'check if match is open to guesses' do
      match_future = build(:future_match)
      match_past = build(:past_match)
      match_future.is_open_to_guesses?.should be_true
      match_past.is_open_to_guesses?.should be_false
    end

    it 'should have a winner' do
      match = build(:match, goals_a: 2, goals_b: 1)
      match.winner.should == :team_a

      match.update_attributes(goals_a: 1, goals_b: 2)
      match.winner.should == :team_b

      match.update_attributes(goals_a: 1, goals_b: 1)
      match.winner.should == :draw
    end

  end
end
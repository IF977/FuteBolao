require 'spec_helper'

describe GuessDecorator do

  it 'should generate classes according to scores' do
    match = create(:past_match, goals_a: 2, goals_b: 1)

    guess_decorated = create(:guess, match: match, goals_a: 0, goals_b: 1).decorate # score 0
    guess_decorated.score_classes.should == ['label']

    guess_decorated.update_attributes(goals_a: 1, goals_b: 0) # score 1
    guess_decorated.score_classes.should == ['label', 'label-warning']

    guess_decorated.update_attributes(goals_a: 2, goals_b: 1) # score 3
    guess_decorated.score_classes.should == ['label', 'label-primary']
  end


  context 'associations' do

    let!(:guess_decorated) { create(:guess).decorate }
    subject { guess_decorated }

    it 'should decorate match association' do
      guess_decorated.match.should be_kind_of(MatchDecorator)
    end

    it 'should decorate user association' do
      guess_decorated.user.should be_kind_of(UserDecorator)
    end

  end

end
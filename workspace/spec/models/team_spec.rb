require 'spec_helper'

describe Team do

  let!(:team) { FactoryGirl.build(:team) }
  subject { team }

  it 'should have a name' do
    team = Team.new
    team.should_not be_valid
  end

  it 'should be valid with a name' do
    team = Team.new
    team.name = 'Team name'
    team.should be_valid
  end

  it 'should define a slug for the team name' do
    team.save
    team.slug.should == team.name.parameterize
  end

end
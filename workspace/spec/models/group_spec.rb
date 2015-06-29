require 'spec_helper'

describe Group do

  let!(:group) { build(:group) }
  subject{ group }

  it { should be_valid }

  its(:active) { should be_true }

  it 'should have a name' do
    group.name = nil
    group.should_not be_valid
  end

  it 'should have matches' do
    group.save
    match_1 = create(:match, group: group)
    match_2 = create(:match, group: group)
    group.should have(2).matches
  end

  it 'should not have matches' do
    group.save
    create(:match)
    group.should have(0).matches
  end

end
require 'spec_helper'

describe User do

  context 'scopes' do

    let!(:user) { create(:user) }
    subject { user }

    it { should be_valid }

    it 'should be able to ushave guesses' do
      guess_1 = create(:guess, user: user)
      guess_2 = create(:guess, user: user)
      guess_3 = create(:guess, user: build(:user)) # another user
      user.should have(2).guesses
    end

    it 'should list public guesses (guesses from ended matches)' do
      guess_future = create(:guess, user: user, match: build(:future_match)) #public
      guess_past   = create(:guess, user: user, match: build(:past_match))

      user.public_guesses.should include(guess_past)
      user.public_guesses.should_not include(guess_future)
    end

    it 'should list the users in a descending order rank' do
      User.update_all(position: nil)

      positions = [1,5,4,2,3,3,7,6]
      positions.each { |p| create(:user, position: p) }

      ranked = User.rank

      positions.sort.each_with_index do |p, i|
        ranked[i].position.should == p
      end
    end

  end
end
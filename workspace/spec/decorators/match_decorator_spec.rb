require 'spec_helper'

describe MatchDecorator do

  context 'associations' do

    let!(:match_decorated) { create(:match).decorate }
    subject { match_decorated }

    it 'should decorate guess association' do
      match_decorated.guesses.should be_kind_of(Draper::CollectionDecorator)
    end

  end

  context 'methods' do

    it 'should format the date' do
      now = Time.now
      match_decorated = create(:match, datetime: now).decorate
      match_decorated.data_hora.should == now.strftime('%d/%m/%Y %Hh')
    end

    it 'should be today' do
      match_decorated = create(:match, datetime: Time.now).decorate
      match_decorated.is_today?.should be_true
    end

    it 'should not be today' do
      match_decorated = create(:future_match).decorate
      match_decorated.is_today?.should be_false
    end

    it 'should formt the time' do
      now = Time.now
      match_decorated = create(:match, datetime: now).decorate
      match_decorated.hora.should == now.strftime('%Hh')
    end

    it 'should return open/close to guesses according to the match time' do
      future_match = create(:future_match).decorate
      past_match   = create(:past_match).decorate
      future_match.open_to_guesses_label.should == I18n.t("open")
      past_match.open_to_guesses_label.should == I18n.t("closed")
    end

    it 'should generate classes according to open / close to guesses' do
      match_decorated = create(:future_match).decorate
      match_decorated.status_classes.should == ['label', 'label-success'] # open to guesses

      match_decorated = create(:past_match).decorate
      match_decorated.status_classes.should == ['label', 'label-danger']
    end

    it 'should attach the user guess to the match' do
      user_1 = create(:user) 
      user_2 = create(:user) 
      match  = create(:future_match)

      # creates guesses from differents users to the match
      guess_user_1 = create(:guess, match: match, user: user_1)
      guess_user_2 = create(:guess, match: match, user: user_2)

      match_decorated = match.decorate(context: {user: user_1})
      match_decorated.my_guess.should == guess_user_1
    end

    it 'should list only guesses which has scores > 0' do
      match = create(:match, goals_a: 3, goals_b: 1).decorate
      create(:guess, match: match, goals_a: 3, goals_b: 1)
      create(:guess, match: match, goals_a: 2, goals_b: 1)
      create(:guess, match: match, goals_a: 3, goals_b: 3)
      create(:guess, match: match, goals_a: 1, goals_b: 3)

      match.should have(4).guesses
      match.should have(2).scorers
    end

    it 'should have only 6 scorers' do
      match = create(:match, goals_a: 3, goals_b: 1)
      create(:guess, match: match, goals_a: 3, goals_b: 1)
      create(:guess, match: match, goals_a: 3, goals_b: 1)
      create(:guess, match: match, goals_a: 3, goals_b: 1)
      create(:guess, match: match, goals_a: 3, goals_b: 1)
      create(:guess, match: match, goals_a: 3, goals_b: 1)
      create(:guess, match: match, goals_a: 3, goals_b: 1)
      create(:guess, match: match, goals_a: 3, goals_b: 1)
      create(:guess, match: match, goals_a: 3, goals_b: 1)

      match_decorated = match.decorate

      match_decorated.should have(8).guesses
      match_decorated.should have(6).scorers_limited
    end

    it 'should have guesses_max equals to users' do
      create(:user)
      create(:user)
      create(:match)
      match = Match.first.decorate
      match.guesses_max.should == User.count      
    end

    it 'should have the progress of guesses made' do
      match = create(:match).decorate
      create(:user)
      create(:user)

      create(:guess, match: match, goals_a: 3, goals_b: 1)
      create(:guess, match: match, goals_a: 2, goals_b: 1)

      match.guesses_progress.should == (match.guesses.size.round(2) / User.count.round(2)) * 100
    end

    it 'should have a progress style class' do
      create(:match)

      styles = {
        24  => "progress-bar-danger",
        49  => "progress-bar-warning",
        74  => "info",
        99  => "progress-bar-active",
        100 => "progress-bar-success"
      }

      styles.each do |total, style|
        MatchDecorator.any_instance.stub(:guesses_progress).and_return(total)
        match = Match.first.decorate
        match.progress_class.should == style
      end
    end

  end
end
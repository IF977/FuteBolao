require 'spec_helper'

describe UserDecorator do

  let!(:user_decorated) { create(:user).decorate }
  subject { user_decorated }

  it 'should not respond to methods not delegated' do
    ['encrypted_password','remember_created_at','created_at','updated_at','uid','provider'].each do |m|
      user_decorated.should_not respond_to(m.to_sym)
    end
  end

  it 'should decorate guesses association' do
    user_decorated.guesses.should be_kind_of(Draper::CollectionDecorator)
  end

  it 'should decorate public guesses association' do
    user_decorated.public_guesses.should be_kind_of(Draper::CollectionDecorator)
  end

  it 'should have a default image from gravatar' do
    user_decorated.profile_image.should == Gravatar.new(user_decorated.email).image_url + "?d=mm"
  end

  it 'should use image from gravatar' do
    user_decorated = build(:user, email: 'josuedsi@gmail.com').decorate
    user_decorated.profile_image.should == "http://www.gravatar.com/avatar/7711ce8a674520d03f28668887b55c9c?d=mm"
  end

  it 'should return user image from facebook' do
    user = create(:user, image: "profile.jpg").decorate
    user.profile_image.should == "profile.jpg"
  end

end
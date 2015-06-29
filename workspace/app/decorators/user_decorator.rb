class UserDecorator < Draper::Decorator
  decorates_association :guesses, with: GuessDecorator
  decorates_association :public_guesses, with: GuessDecorator
  
  delegate :id, :name, :score, :admin, :position, :image, :email

  def profile_image
    image.nil? ? Gravatar.new(email).image_url + "?d=mm" : image
  end

end
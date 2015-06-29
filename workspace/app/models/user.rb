class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :rememberable,
         :validatable, :omniauthable, omniauth_providers: [:facebook]

  validates :name, presence: true

  has_many :guesses

  # guesses for matches finished or started
  has_many :public_guesses, -> { joins(:match).where("matches.datetime <= ?", Time.now).order("matches.datetime DESC") }, 
           class_name: 'Guess', primary_key: :id, foreign_key: :user_id

  # put the users with no points (null = new user) to the end of the list
  scope :rank, -> { order('position IS NULL, position ASC') }

  def self.find_for_facebook_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.id = auth.id
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.image = auth.info.image
    end
  end

end
class Guess < ActiveRecord::Base
  include Winnerable

  validates :user,    presence: true
  validates :match,   presence: true
  validates :goals_a, presence: true
  validates :goals_b, presence: true

  validates :match, uniqueness: { scope: :user }

  belongs_to :user
  belongs_to :match

  scope :finished, -> { joins(:match).where("matches.datetime < ?", Time.now) }

  def score
    return 0 if !match.finished?
    return 3 if match.goals_a == goals_a && match.goals_b == goals_b
    return 1 if match.winner == winner
    0
  end

  def to_s
    "#{goals_a} x #{goals_b}"
  end
end

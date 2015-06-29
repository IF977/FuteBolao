class Match < ActiveRecord::Base
  include Winnerable

  validates :datetime, presence: true
  validates :group,    presence: true
  validates :team_a,   presence: true
  validates :team_b,   presence: true

  belongs_to :team_a, class_name: 'Team', primary_key: :id, foreign_key: :team_a_id
  belongs_to :team_b, class_name: 'Team', primary_key: :id, foreign_key: :team_b_id
  belongs_to :group

  has_many :guesses

  scope :active, -> { joins(:group).where("groups.active = ?", true) }
  scope :open_to_guesses, -> { where("datetime > ?", Time.now) }
  scope :group_ordered, -> { joins(:group).order("groups.name") }
  scope :today, -> { where("DATE(datetime) = DATE(?)", Time.now).order(:datetime) }

  def finished?
    !goals_a.nil? && !goals_b.nil?
  end

  def is_open_to_guesses?
    self.datetime > Time.now
  end
end
class Group < ActiveRecord::Base
  has_many :matches
  validates :name, presence: true
end

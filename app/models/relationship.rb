class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  enum :status, not_connected: 0, requested: 1, accepted: 2, rejected: 3

  scope :following, -> { where(status: "accepted") }
  scope :followers, -> { where(status: "accepted") }
end

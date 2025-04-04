class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  enum :status, not_connected: 0, requested: 1, pending: 2, accepted: 3, rejected: 4
end

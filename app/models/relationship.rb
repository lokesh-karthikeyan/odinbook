class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  enum status: { not_connected: 0, pending: 1, accepted: 2, rejected: 3 }
end

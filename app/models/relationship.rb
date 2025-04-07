class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"

  enum :status, not_connected: 0, requested: 1, accepted: 2, rejected: 3

  scope :following, -> { where(status: "accepted") }
  scope :followers, -> { where(status: "accepted") }

  scope(
    :between_users,
    ->(user1, user2) {
      where(
        "(follower_id = :user1_id AND followee_id = :user2_id) OR
         (follower_id = :user2_id AND followee_id = :user1_id)",
        user1_id: user1.id,
        user2_id: user2.id
      )
    }
  )

  scope(
    :rejected_between_users,
    ->(user1, user2) {
      where(
        "(follower_id = :user1_id AND followee_id = :user2_id) OR
       (follower_id = :user2_id AND followee_id = :user1_id)",
        user1_id: user1.id,
        user2_id: user2.id
      )
        .where(status: :rejected)
    }
  )
end

class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :media

  has_many :comments
  has_many :likes
end

class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :media

  has_many :comments, dependent: :destroy
  has_many :commenters, through: :comments, source: :user

  has_many :likes, dependent: :destroy
end

class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :media

  has_many :comments, dependent: :destroy
  has_many :commenters, through: :comments, source: :user

  has_many :likes, dependent: :destroy

  validate :media_format
  validate :content_or_media_presence

  private

  def media_format
    if media.attached? && !media.content_type.in?(%w[image/jpeg image/jpg image/png image/svg+xml])
      errors.add(:media, "must be a PNG, JPEG, JPG, or SVG file")
    end
  end

  def content_or_media_presence
    if content.blank? && !media.attached?
      errors.add(:base, "Post must have either content or media attached")
    end
  end
end

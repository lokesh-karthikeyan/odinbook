class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile
  has_one_attached :avatar

  validates :name, presence: true, length: { minimum: 4, maximum: 30 }
  validates :username, presence: true, length: { minimum: 3, maximum: 15 }, uniqueness: true
  validate :avatar_format

  private

  def avatar_format
    if avatar.attached? && !avatar.content_type.in?(%w[image/png image/jpeg image/jpg image/svg+xml])
      errors.add(:avatar, "must be a PNG, JPG, JPEG or SVG file")
    end
  end
end

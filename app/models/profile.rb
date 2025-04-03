class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile
  has_one_attached :avatar
end

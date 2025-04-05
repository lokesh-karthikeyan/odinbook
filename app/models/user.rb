class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :validatable,
    :omniauthable,
    omniauth_providers: %i[github]
  )

  after_create :create_profile, :attach_avatar, :generate_random_name

  has_many :active_relations, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relations, source: :followee

  has_many :passive_relations, class_name: "Relationship", foreign_key: "followee_id", dependent: :destroy
  has_many :followers, through: :passive_relations, source: :follower

  has_many :posts, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_one :profile, inverse_of: :user, dependent: :destroy

  scope(
    :not_connected_users,
    ->(current_user) {
      where
        .not(id: current_user.id)
        .where
        .not(id: current_user.following.pluck(:id))
        .or(where(id: current_user.active_relations.not_connected.pluck(:followee_id)))
        .or(where(id: current_user.active_relations.requested.pluck(:followee_id)))
    }
  )

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.profile.name = auth.info.name
      user.profile.bio = auth.info.bio
      user.create_profile
      user.generate_random_name
    end
  end

  private

  def create_profile = (build_profile(username: generate_unique_username).save)

  def base_username = (email.split("@").first)

  def generate_unique_username
    loop do
      unique_username = "#{base_username}_#{SecureRandom.hex(2)}"
      break unique_username unless Profile.exists?(username: unique_username)
    end
  end

  def generate_random_name = (profile.update(name: NameGenerator.generate) unless self&.profile&.name&.present?)

  def attach_avatar
    initials = base_username.first.upcase
    svg_content = AvatarGenerator.create_initials_avatar(initials)
    temp_file = Tempfile.new([ "avatar", ".svg" ], binmode: true)
    temp_file.write(svg_content)
    temp_file.rewind
    profile.avatar.attach(io: temp_file, filename: "avatar.svg", content_type: "image/svg+xml")
  end
end

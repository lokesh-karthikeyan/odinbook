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

  after_create :setup_profile

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true

  attr_accessor :oauth_name, :oauth_bio

  has_many(
    :active_relations,
    -> { where(status: :accepted) },
    class_name: "Relationship",
    foreign_key: "follower_id",
    dependent: :destroy
  )
  has_many :following, through: :active_relations, source: :followee

  has_many(
    :passive_relations,
    -> { where(status: :accepted) },
    class_name: "Relationship",
    foreign_key: "followee_id",
    dependent: :destroy
  )
  has_many :followers, through: :passive_relations, source: :follower

  has_many(
    :requested_active_relations,
    -> { where(status: :requested) },
    class_name: "Relationship",
    foreign_key: "follower_id",
    dependent: :destroy
  )
  has_many :requests, through: :requested_active_relations, source: :followee

  has_many(
    :requested_passive_relations,
    -> { where(status: :requested) },
    class_name: "Relationship",
    foreign_key: "followee_id",
    dependent: :destroy
  )
  has_many :pending_requests, through: :requested_passive_relations, source: :follower

  has_many :posts, dependent: :destroy

  has_many :comments, dependent: :destroy
  has_many :commented_posts, through: :comments, source: :post

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_one :profile, inverse_of: :user, dependent: :destroy

  scope(
    :not_connected_users,
    ->(current_user) {
      connected_user_ids = current_user.following.pluck(:id) + current_user.followers.pluck(:id)
      sent_request_ids = current_user.requests.pluck(:id)
      pending_request_ids = current_user.pending_requests.pluck(:id)
      excluded_ids = connected_user_ids + pending_request_ids + [ current_user.id ]

      where.not(id: excluded_ids).or(where(id: sent_request_ids))
    }
  )

  def rejected_with?(other_user)
    Relationship.rejected_between_users(self, other_user).exists?
  end

  def self.from_omniauth(auth)
    new_user = find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]

      user.oauth_name = auth.info.name
      user.oauth_bio = auth.info.bio || ""
    end

    new_user
  end

  private

  def setup_profile
    profile_data = if provider && uid
      {
        name: oauth_name || generate_random_name,
        username: generate_unique_username,
        bio: oauth_bio || ""
      }
    else
      { name: generate_random_name, username: generate_unique_username, bio: "" }
    end

    build_profile(profile_data)
    profile.save

    attach_avatar if profile.avatar.blank?
    UserMailer.with(user: self).welcome.deliver_now
  end

  def base_username = (email.split("@").first)

  def generate_unique_username
    loop do
      unique_username = "#{base_username}_#{SecureRandom.hex(2)}"
      break unique_username unless Profile.exists?(username: unique_username)
    end
  end

  def generate_random_name = (NameGenerator.generate)

  def attach_avatar
    initials = base_username.first.upcase
    svg_content = AvatarGenerator.create_initials_avatar(initials)
    temp_file = Tempfile.new([ "avatar", ".svg" ], binmode: true)
    temp_file.write(svg_content)
    temp_file.rewind
    profile.avatar.attach(io: temp_file, filename: "avatar.svg", content_type: "image/svg+xml")
  end
end

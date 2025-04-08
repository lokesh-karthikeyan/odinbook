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

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true

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
    end

    if new_user
      new_user.build_profile(
        name: auth.info.name || new_user.generate_random_name,
        bio: auth.info.bio,
        username: new_user.generate_unique_username
      )
      new_user.profile.save
      new_user.attach_avatar
    end

    new_user
  end

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

  private

  def create_profile = (build_profile(username: generate_unique_username).save)

  def base_username = (email.split("@").first)
end

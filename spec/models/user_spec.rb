require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to(have_many(:active_relations).with_foreign_key("follower_id").class_name("Relationship")) }
  it { is_expected.to(have_many(:following).through(:active_relations).source(:followee)) }

  it { is_expected.to(have_many(:passive_relations).with_foreign_key("followee_id").class_name("Relationship")) }
  it { is_expected.to(have_many(:followers).through(:passive_relations).source(:follower)) }

  it { is_expected.to(have_many(:posts)) }

  it { is_expected.to(have_many(:comments)) }
  it { is_expected.to(have_many(:commented_posts).through(:comments).source(:post)) }

  it { is_expected.to(have_many(:likes)) }
  it { is_expected.to(have_many(:liked_posts).through(:likes).source(:post)) }

  it { is_expected.to(have_one(:profile)) }

  context("When the user is registering") do
    it "should generate an username" do
      user = create(:user)
      expect(user.profile.username).to(be_present)
    end

    it "should generate an avatar" do
      user = create(:user)
      expect(user.profile.avatar.attached?).to(be_present)
    end

    it "should generate a name" do
      user = create(:user)
      expect(user.profile.name).to(be_present)
    end
  end

  context("Validation tets") do
    context("When email is empty") do
      it "is expected to be invalid" do
        user = build(:user, email: "")
        expect(user).not_to(be_valid)
      end
    end

    context("When email is not unique") do
      it "is expected to be invalid" do
        user1 = create(:user)
        user2 = build(:user, email: user1.email)
        expect(user2).not_to(be_valid)
      end
    end

    context("When password is empty") do
      it "is expected to be invalid" do
        user = build(:user, password: "")
        expect(user).not_to(be_valid)
      end
    end

    context("When password is less than 6 characters") do
      it "is expected to be invalid" do
        user = build(:user, password: "12345")
        expect(user).not_to(be_valid)
      end
    end

    context("When password is present/above 6 characters & email is unique") do
      it "is expected to be valid" do
        user = build(:user, password: "123456")
        expect(user).to(be_valid)
      end
    end
  end
end

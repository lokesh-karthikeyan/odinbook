require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to(have_many(:active_relations).with_foreign_key("follower_id").class_name("Relationship")) }
  it { is_expected.to(have_many(:following).through(:active_relations).source(:followee)) }

  it { is_expected.to(have_many(:passive_relations).with_foreign_key("followee_id").class_name("Relationship")) }
  it { is_expected.to(have_many(:followers).through(:passive_relations).source(:follower)) }

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
end

require "rails_helper"

RSpec.describe Profile, type: :model do
  it { is_expected.to(belong_to(:user)) }

  context("Validation tests -> Name") do
    context("When the name is empty") do
      it "should be invalid" do
        profile = build(:profile, name: "")
        expect(profile).not_to(be_valid)
      end
    end

    context("When the name is less than 4 characters") do
      it "should be invalid" do
        profile = build(:profile, name: "123")
        expect(profile).not_to(be_valid)
      end
    end

    context("When the name is greater than 4 characters") do
      it "should be valid" do
        profile = build(:profile, name: "1234")
        expect(profile).to(be_valid)
      end
    end
  end

  context("Validation tests -> Username") do
    context("When the username is empty") do
      it "should be invalid" do
        profile = build(:profile, username: "")
        expect(profile).not_to(be_valid)
      end
    end

    context("When the username is less than 3 characters") do
      it "should be invalid" do
        profile = build(:profile, username: "12")
        expect(profile).not_to(be_valid)
      end
    end

    context("When the username is not unique") do
      it "should be invalid" do
        profile1 = create(:profile, username: "user")
        profile2 = build(:profile, username: profile1.username)
        expect(profile2).not_to(be_valid)
      end
    end

    context("When the username is greater than 4 characters & unique") do
      it "should be valid" do
        profile = build(:profile, username: "user")
        expect(profile).to(be_valid)
      end
    end
  end

  context("Validation tests -> Avatar") do
    context("When the avatar attachment is invalid type") do
      it "should be invalid" do
        profile = build(
          :profile,
          avatar: Rack::Test::UploadedFile.new("spec/fixtures/invalid.txt", "text/plain")
        )
        expect(profile).not_to(be_valid)
      end
    end

    context("When the avatar attachment is valid type") do
      it "should be valid" do
        profile = build(:profile)
        expect(profile).to(be_valid)
      end
    end
  end
end

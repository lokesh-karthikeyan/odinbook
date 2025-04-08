require "rails_helper"

RSpec.describe Post, type: :model do
  it { is_expected.to(belong_to(:user)) }
  it { is_expected.to(have_many(:commenters).through(:comments).source(:user)) }

  it { is_expected.to(have_many(:comments)) }
  it { is_expected.to(have_many(:likes)) }

  context("Validation tests -> Content/Media") do
    context("When both media & content is empty") do
      it "should be invalid" do
        post = build(:post, media: nil, content: nil)
        expect(post).not_to(be_valid)
      end
    end

    context("When the content is present & media is invalid type") do
      it "should be invalid" do
        post = build(:post, media: Rack::Test::UploadedFile.new("spec/fixtures/invalid.txt", "text/plain"))
        expect(post).not_to(be_valid)
      end
    end

    context("When the content is empty & media is invalid type") do
      it "should be invalid" do
        post = build(
          :post,
          content: nil,
          media: Rack::Test::UploadedFile.new("spec/fixtures/invalid.txt", "text/plain")
        )
        expect(post).not_to(be_valid)
      end
    end

    context("When both the content & media is present with valid type") do
      it "should be valid" do
        post = build(:post, media: Rack::Test::UploadedFile.new("spec/fixtures/valid.png", "image/png"))
        expect(post).to(be_valid)
      end
    end

    context("When the valid media is present & content is empty") do
      it "should be valid" do
        post = build(:post, content: nil, media: Rack::Test::UploadedFile.new("spec/fixtures/valid.png", "image/png"))
        expect(post).to(be_valid)
      end
    end

    context("When the content is present & media is empty") do
      it "should be valid" do
        post = build(:post, media: nil)
        expect(post).to(be_valid)
      end
    end
  end
end

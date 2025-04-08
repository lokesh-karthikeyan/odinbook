require "rails_helper"

RSpec.describe Comment, type: :model do
  it { is_expected.to(belong_to(:post)) }
  it { is_expected.to(belong_to(:user)) }

  context("Validation tests -> content") do
    context("When the content is empty") do
      it "should be invalid" do
        comment = build(:comment, content: nil)
        expect(comment).not_to(be_valid)
      end
    end

    context("When the content is not empty") do
      it "should be valid" do
        comment = build(:comment)
        expect(comment).to(be_valid)
      end
    end
  end
end

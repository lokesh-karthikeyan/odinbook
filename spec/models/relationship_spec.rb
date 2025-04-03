require "rails_helper"

RSpec.describe Relationship, type: :model do
  it { is_expected.to(belong_to(:follower).class_name("User")) }
  it { is_expected.to(belong_to(:followee).class_name("User")) }
end

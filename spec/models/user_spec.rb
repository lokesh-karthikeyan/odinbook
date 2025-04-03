require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to(have_many(:active_relations).with_foreign_key("follower_id").class_name("Relationship")) }
  it { is_expected.to(have_many(:following).through(:active_relations).source(:followee)) }

  it { is_expected.to(have_many(:passive_relations).with_foreign_key("followee_id").class_name("Relationship")) }
  it { is_expected.to(have_many(:followers).through(:passive_relations).source(:follower)) }
end

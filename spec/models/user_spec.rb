require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to(have_many(:followers).through(:relationships)) }
  it { is_expected.to(have_many(:following).through(:relationships)) }
end

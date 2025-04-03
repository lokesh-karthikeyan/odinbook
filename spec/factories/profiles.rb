FactoryBot.define do
  factory :profile do
    username { "MyString" }
    name { "MyString" }
    bio { "MyText" }
    avatar { nil }
    user { nil }
  end
end

FactoryBot.define do
  factory(:profile) do
    username { "MyString" }
    name { "MyString" }
    bio { "MyText" }
    avatar { Rack::Test::UploadedFile.new("spec/fixtures/valid.png", "image/png") }
    association(:user)
  end
end

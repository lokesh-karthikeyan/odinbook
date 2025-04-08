FactoryBot.define do
  factory(:post) do
    content { "Random Content" }
    media { Rack::Test::UploadedFile.new("spec/fixtures/valid.png", "image/png") }
    association(:user)
  end
end

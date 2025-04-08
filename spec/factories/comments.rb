FactoryBot.define do
  factory(:comment) do
    content { "Post has a comment" }
    association(:user)
    association(:post)
  end
end

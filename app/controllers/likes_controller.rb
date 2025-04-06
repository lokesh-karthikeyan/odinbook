class LikesController < ApplicationController
  before_action :set_post

  def create
    @like = @post.likes.new(user: current_user)

    if @like.save
      render(json: { like_count: @post.likes.count })
    else
      render(json: { error: "Unable to like post" }, status: :unprocessable_entity)
    end
  end

  def destroy
    @like = @post.likes.find_by(user: current_user)

    if @like && @like.destroy
      render(json: { like_count: @post.likes.count })
    else
      render(json: { error: "Unable to unlike post" }, status: :unprocessable_entity)
    end
  end

  private

  def set_post = (@post = Post.find(params[:id]))
end

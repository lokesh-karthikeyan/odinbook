class PostsController < ApplicationController
  def index
    @posts = Post.includes(user: :profile)
  end

  def feed
    @posts = current_user.posts
  end

  def new
    @post = current_user.posts.build
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      respond_to do |format|
        format.html { redirect_to(homepage_path, notice: "Post was successfully created") }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  private

  def post_params
  end
end

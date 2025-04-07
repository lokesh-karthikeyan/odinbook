class UsersController < ApplicationController
  def index
    @users = User.not_connected_users(current_user)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts

    @relationship = Relationship.between_users(current_user, @user).first
  end

  def posts
    @user = User.find(params[:id])
    @posts = @user.posts

    respond_to do |format|
      format.turbo_stream
    end
  end

  def following
    @user = User.find(params[:id])
    @following = @user.following

    respond_to do |format|
      format.turbo_stream
    end
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.followers

    respond_to do |format|
      format.turbo_stream
    end
  end

  def liked_posts
    @user = User.find(params[:id])
    @liked_posts = @user.liked_posts.order(created_at: :desc)
  end

  def commented_posts
    Rails.logger.debug("xxxx#{params}")
    @user = User.find(params[:id])
    @commented_posts = @user.commented_posts.distinct.order(updated_at: :desc)
  end
end

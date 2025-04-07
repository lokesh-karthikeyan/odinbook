class UsersController < ApplicationController
  def index
    @users = User.not_connected_users(current_user)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
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
end

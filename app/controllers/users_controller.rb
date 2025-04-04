class UsersController < ApplicationController
  def index
    @users = User.not_connected_users(current_user)
  end

  def show
    @user = User.find(params[:id])
  end
end

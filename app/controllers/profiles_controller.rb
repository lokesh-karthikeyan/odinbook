class ProfilesController < ApplicationController
  def show
    @user = current_user
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit
    @user = User.find_by(id: params[:user_id]) || current_user
    @profile = @user.profile
  end

  def update
    @user = current_user
    @profile = @user.profile

    if current_user
        .profile
        .update(
          name: profile_params[:name],
          username: profile_params[:username],
          bio: profile_params[:bio],
          avatar: profile_params[:avatar]
        )
      flash[:notice] = "Profile updated successfully!"
      redirect_to(user_profile_path(current_user))
    else
      flash.now[:error] = "An Error occured!"
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def profile_params = params.expect(profile: [ :avatar, :name, :username, :bio ])
end

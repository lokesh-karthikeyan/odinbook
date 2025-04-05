class ProfilesController < ApplicationController
  def show
  end

  def edit
    @user = current_user
  end

  def update
    if current_user
        .profile
        .update(
          name: profile_params[:name],
          username: profile_params[:username],
          bio: profile_params[:bio],
          avatar: profile_params[:avatar]
        )
      flash[:message] = "Profile updated successfully!"
      redirect_to(user_profile_path(current_user))
    else
      flash.now[:alert] = "An Error occured!"
      render(:edit, status: :unprocessable_entity)
    end
  end

  private

  def profile_params = params.expect(profile: [ :avatar, :name, :username, :bio ])
end

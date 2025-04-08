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

    if profile_params[:avatar].blank?
      filtered_params = profile_params.except(:avatar)
    else
      filtered_params = profile_params
    end

    if @profile.update(filtered_params)
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

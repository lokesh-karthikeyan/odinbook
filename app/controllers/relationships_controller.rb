class RelationshipsController < ApplicationController
  def create
    user_to_follow = User.find(relationship_params[:other_user])
    relationship = Relationship.new(follower: current_user, followee: user_to_follow, status: :requested)

    if relationship.save
      respond_to do |format|
        format.turbo_stream {
          render(
            turbo_stream: turbo_stream.replace(
              "follow_link_#{user_to_follow.id}",
              partial: "users/links/requested",
              locals: { other_user: user_to_follow }
            )
          )
          flash.now[:notice] = "Request has been successfully sent to #{user_to_follow.profile.name}"
        }
      end
    else
      redirect_to(user_to_follow.profile, alert: "Failed to send follow request.")
    end
  end

  def show = (@users = current_user.pending_requests)

  def update
    context = relationship_params[:context]
    relationship = Relationship.find_by(follower_id: relationship_params[:other_user], followee_id: current_user.id)
    other_user = User.find(relationship_params[:other_user])

    if relationship_params[:status] == "accepted"
      relationship.update(status: :accepted)
      flash[:notice] = "#{relationship.follower.profile.name} is now following you!"
      if context.eql?("relationship_page")
        render(turbo_stream: turbo_stream.replace("new_request_#{other_user.id}", ""))
      elsif context.eql?("user_profile_page")
        render(
          turbo_stream: turbo_stream.replace(
            "relations_status",
            partial: "users/links/accepted",
            locals: { user: other_user }
          )
        )
      end
    elsif relationship_params[:status] == "rejected"
      relationship.update(status: :rejected)
      flash[:notice] = "Follow request rejected."
      if context.eql?("relationship_page")
        render(turbo_stream: turbo_stream.replace("new_request_#{other_user.id}", ""))
      elsif context.eql?("user_profile_page")
        render(
          turbo_stream: turbo_stream.replace(
            "relations_status",
            partial: "users/links/rejected",
            locals: { user: other_user }
          )
        )
      end
    else
      redirect_to(relationship_path, alert: "Invalid status update.")
    end
  end

  def destroy
    other_user = User.find(params[:id])
    relationship = Relationship.between_users(current_user, other_user).first

    if relationship
      relationship.destroy
      flash[:notice] = "You have unfollowed #{relationship.followee.profile.name}."
      render(
        turbo_stream: turbo_stream.replace(
          "follow_link_#{other_user.id}",
          partial: "users/links/follow",
          locals: { other_user: other_user }
        )
      )
    else
      redirect_to(relationship_path, alert: "Unable to unfollow the user.")
    end
  end

  private

  def relationship_params
    params.permit(:other_user, :status, :id, :_method, :context)
  end
end

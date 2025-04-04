class RelationshipsController < ApplicationController
  def create
    other_user = User.find(relationship_params[:other_user])
    Relationship.create(follower_id: current_user.id, followee_id: other_user.id, status: :requested)
    Relationship.create(follower_id: other_user.id, followee_id: current_user.id, status: :pending)

    respond_to do |format|
      format.turbo_stream {
        render(
          turbo_stream: turbo_stream.replace(
            "follow_link_#{other_user.id}",
            partial: "users/links/requested",
            locals: { other_user: other_user }
          )
        )
        flash.now[:notice] = "Request has been successfully sent to #{other_user.profile.name}"
      }
    end
  end

  private

  def relationship_params = params.permit(:other_user)
end

class PostsController < ApplicationController
  def feed
    current_user_and_following_ids = [ current_user.id ] + current_user.following.pluck(:id)
    @posts = Post
      .includes(user: :profile)
      .where(user_id: current_user_and_following_ids)
      .order(created_at: :desc)
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
    @post.media.attach(post_params[:media]) if post_params[:media].present?

    if @post.save
      respond_to do |format|
        format.html { redirect_to(authenticated_homepage_path, notice: "Post was successfully created") }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  def destroy
    post = Post.find(params[:id])

    if post.destroy
      flash[:notice] = "Post was successfully deleted"
      render(turbo_stream: turbo_stream.remove(post))
    else
      redirect_to(authenticated_homepage_path, alert: "Failed to delete the post.")
    end
  end

  private

  def post_params = (params.expect(post: [ :content, :media, :id ]))
end

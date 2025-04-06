class CommentsController < ApplicationController
  def new
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to(:authenticated_homepage) }
    end
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)

    @comment.user_id = current_user.id

    if @comment.save
      respond_to do |format|
        format.html { redirect_to(authenticated_homepage_path, notice: "Comment has been successfully submitted") }
        format.turbo_stream
      end
    else
      render(:new, status: :unprocessable_entity)
    end
  end

  private

  def comment_params = (params.expect(comment: [ :content ]))
end

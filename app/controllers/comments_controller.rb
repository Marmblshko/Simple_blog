class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  def create
    @post = Post.find(params[:post_id])
    @post.comments.create(comment_params) do |c|
      c.author = current_user.username
    end

    redirect_to posts_path(@post)
  end

  private

  def comment_params
    params.require(:comment).permit(:author,:body)
  end
end
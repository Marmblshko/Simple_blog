class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[create destroy]
  before_action :check_owner, only: %i[destroy]

  def create
    @post.comments.create(comment_params) do |c|
      c.author = current_user.username
    end

    redirect_to @post, notice: 'Comment added!'
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to @post, notice: 'Comment deleted!'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def check_owner
    @comment = @post.comments.find(params[:id])
    unless current_user.username == @comment.author
      redirect_to @post, notice: "You can`t delete this comment."
    end
  end

  def comment_params
    params.require(:comment).permit(:author, :body)
  end
end
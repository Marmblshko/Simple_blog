class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_post, only: %i[create destroy]

  def create
    @post.comments.create(comment_params) do |c|
      c.author = current_user.username
    end

    redirect_to @post
  end

  def destroy
    @comment = @post.comments.find params[:id]
    @comment.destroy
    redirect_to @post
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:author, :body)
  end
end
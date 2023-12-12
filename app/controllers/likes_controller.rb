class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @likeable = set_likeable
    @like = @likeable.likes.build(user: current_user)

    if @like.save
      redirect_to @likeable, notice: 'Like added!'
    else
      redirect_to @likeable, notice: 'Failed to add like'
    end
  end

  def destroy
    @like = Like.find(params[:id])
    @likeable = @like.likeable
    @like.destroy
    redirect_to @likeable, notice: 'Like removed!'
  end

  private

  def set_likeable
    if params[:post_id]
      Post.find(params[:post_id])
    elsif params[:comment_id]
      Comment.find(params[:comment_id])
    end
  end
end

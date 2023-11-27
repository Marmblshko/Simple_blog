class LikesController < ApplicationController
  before_action :set_likable, only: %i[create destroy]
  before_action :authenticate_user!

  def create
    @like = @object.likes.new(user_id: current_user.id)

    if @like.save
      redirect_to @object, notice: 'Like added!'
    else
      redirect_to @object, notice: 'Failed to add like'
    end
  end

  def destroy
    @like = Like.find_by(user_id: current_user.id)
    @like.destroy
    redirect_to @object, notice: 'Like removed!'
  end

  private

  def set_likable
    if params[:post_id]
      @object = Post.find(params[:post_id])
    elsif params[:comment_id]
      @object = Comment.find(params[:comment_id])
    end
  end
end
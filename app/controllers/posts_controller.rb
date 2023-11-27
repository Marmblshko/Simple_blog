class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_post, except: %i[index new create]
  before_action :check_owner, only: %i[edit update destroy]

  def index
    @posts = Post.all
  end

  def show
  end

  def new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to @post, notice: 'Post created!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post updated!'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post deleted!'
  end

  def check_owner
    unless current_user == User.find(@post.user_id)
      redirect_to posts_path, notice: "You do not have permission to mod this post."
    end
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create]
  # before_action :check_owner, only: %i[edit update destroy]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to @post
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to @post
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  def check_owner
    unless current_user == @post.user
      redirect_to @posts, alert: "У вас нет разрешения на редактирование этой статьи."
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :text)
  end
end
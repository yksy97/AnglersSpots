class Public::PostsController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update, :destroy]

  def show
    @post = Post.find(params[:id])
    @post_comment = PostComment.new
    @post_comments = @post.post_comments.order(created_at: :desc)
  end

  def index
    @posts = Post.includes(:customer, :genre).order(created_at: :desc)
    @post = Post.new
    @following_posts = Post.where(customer_id: current_customer.followings.pluck(:id)).order(created_at: :desc)
    @my_posts = current_customer.posts.order(created_at: :desc)
    @favorited_posts = current_customer.favorites.includes(:post).map(&:post)
    @genres = Genre.order(:name)
  end

  def create
    @post = current_customer.posts.build(post_params)

    if params[:post][:new_genre_name].present?
      genre = Genre.find_or_create_by(name: params[:post][:new_genre_name])
      @post.genre_id = genre.id
    end

    if @post.save
      redirect_to posts_path, notice: "投稿が完了しました"
    else
      @posts = Post.includes(:customer, :genre).order(created_at: :desc)
      @following_posts = Post.where(customer_id: current_customer.followings.pluck(:id)).order(created_at: :desc)
      @my_posts = current_customer.posts.order(created_at: :desc)
      @favorited_posts = current_customer.favorites.includes(:post).map(&:post)
      @genres = Genre.order(:name)
      render :index
    end
  end

  def genre
    genre = Genre.find(params[:id])
    @posts = genre.posts
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿が更新されました"
    else
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "投稿が削除されました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image, :genre_id, :rig, :location)
  end

  def ensure_correct_customer
    @post = Post.find(params[:id])
    unless @post.customer == current_customer
      redirect_to posts_path, alert: '権限がありません。'
    end
  end
end

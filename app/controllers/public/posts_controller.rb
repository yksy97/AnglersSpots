class Public::PostsController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
    @genres = Genre.order(:name)
    @tackles = Tackle.all
  end

  def index
    if params[:rig_id]
      @posts = Rig.find(params[:rig_id]).posts.includes(:customer).order(created_at: :desc).page(params[:page]).per(6)
    elsif params[:location]
      @posts = Post.where(location: params[:location]).includes(:customer).order(created_at: :desc).page(params[:page]).per(6)
    elsif params[:genre_name]
      @posts = Post.where(genre_name: params[:genre_name]).includes(:customer).order(created_at: :desc).page(params[:page]).per(6)
    else
      @posts = Post.includes(:customer).order(created_at: :desc).page(params[:page]).per(6)
    end
    @post = Post.new
    @genres = Genre.order(:name)
    @tackles = Tackle.all
  end

  def show
    @post = Post.find(params[:id])
    @customer = @post.customer
    @post_comment = PostComment.new
    @post_comments = @post.post_comments.order(created_at: :desc)
  end

  def create
    @post = current_customer.posts.build(post_params)
    if params[:post][:new_genre_name].present?
      genre = Genre.find_or_create_by(name: params[:post][:new_genre_name], customer_id: current_customer.id )
      @post.genre_name = genre.name
    end
    respond_to do |format|
      if @post.save
        @post.save_rigs(params[:post][:rig_list])
        format.html { redirect_to posts_path, notice: "投稿が完了しました" }
        format.js
      else
        @posts = Post.includes(:customer, :genre).order(created_at: :desc).page(params[:page]).per(6)
        @my_posts = current_customer.posts.order(created_at: :desc).page(params[:page]).per(6)
        @genres = Genre.order(:name)
        @tackles = Tackle.all
        format.html { render :index }
        format.js
      end
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

  def tackle_selection
    @post = Post.find(params[:id])
    if @post.update(tackle_id: params[:post][:tackle_id])
      redirect_to @post, notice: '登録したタックルが適用されました'
    else
      render :edit, alert: '登録したタックルの適用に失敗しました'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "投稿が削除されました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image, :genre_name, :location, :tackle_id, :rig_list)
  end

  def ensure_correct_customer
    @post = Post.find(params[:id])
    unless @post.customer == current_customer
      redirect_to posts_path, alert: '権限がありません'
    end
  end
end
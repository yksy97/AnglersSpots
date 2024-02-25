class Public::GenresController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_genre, only: [:edit, :update, :destroy]

  def index
    @genres = current_customer.genres.order(created_at: :desc).page(params[:page]).per(20)
    @genre = current_customer.genres.new
  end
    
  def create
    @genre = current_customer.genres.new(genre_params)
    if @genre.save
      redirect_to genres_path, notice: '新しい魚が登録されました'
    else
      @genres = current_customer.genres.order(:name).page(params[:page]).per(20)
      render :index
    end
  end

  def edit
    
  end

  def update
    if @genre.update(genre_params)
      redirect_to genres_path, notice: '魚が更新されました'
    else
      @genres = Genre.all.order(:name)
      render :index
    end
  end

  def destroy
    @genre.destroy
    redirect_to genres_path, notice: '魚が削除されました'
  end

  private

  def set_genre
    @genre = current_customer.genres.find(params[:id])
  end

  def genre_params
    params.require(:genre).permit(:name)
  end
end
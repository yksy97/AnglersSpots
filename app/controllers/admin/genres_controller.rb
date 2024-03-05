class Admin::GenresController < ApplicationController
  class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!

  def index
    @genres = Genre.order(created_at: :desc).page(params[:page]).per(12)
  end


  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to admin_genres_path, notice: '魚種が登録されました'
    else
      render :new
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update(genre_params)
      redirect_to admin_genres_path, notice: '魚種が更新されました'
    else
      render :edit
    end
  end

  def destroy
    @genre = Genre.find(params[:id])
    @genre.destroy
    redirect_to admin_genres_path, notice: '魚種が削除されました'
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end
end

end

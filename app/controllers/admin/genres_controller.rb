class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!

  def index
    @genres = Genre.order(created_at: :desc).page(params[:page]).per(12)
  end

  def destroy
    @genre = Genre.find(params[:id])
    if @genre.destroy
      redirect_to admin_genres_path, notice: '魚種が削除されました'
    else
      redirect_to admin_genres_path, alert: '魚種の削除に失敗しました'
    end
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end
end
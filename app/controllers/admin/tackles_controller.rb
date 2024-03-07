class Admin::TacklesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @tackles = Tackle.order(created_at: :desc).page(params[:page]).per(6)
  end

  def show
    @tackle = Tackle.find(params[:id])
  end

  def destroy
    @tackle = Tackle.find(params[:id])
    if @tackle.destroy
      redirect_to admin_tackles_path, notice: 'タックルが削除されました'
    else
      redirect_to admin_tackles_path, alert: 'タックルの削除に失敗しました'
    end
  end

  private

  def tackle_params
    params.require(:tackle).permit(:name)
  end
end
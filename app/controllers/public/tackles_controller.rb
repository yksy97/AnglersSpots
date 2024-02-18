class Public::TacklesController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_tackle, only: [:edit, :update, :destroy]
  
  def new
    @tackle = Tackle.new
  end
  
  def index
    @tackles = current_customer.tackles
  end

  def create
    @tackle = current_customer.tackles.build(tackle_params)
    if @tackle.save
      redirect_to tackles_path, notice: 'タックルが登録されました'
    else
      render :new
    end
  end

  def edit
    @tackle = Tackle.find(params[:id])
  end

  def update
    @tackle = Tackle.find(params[:id])
    if @tackle.update(tackle_params)
      redirect_to tackles_path, notice: 'タックルが更新されました'
    else
      render :edit
    end
  end

  def destroy
    @tackle = Tackle.find(params[:id])
    @tackle.destroy
    redirect_to root_path, notice: 'タックルが削除されました'
  end

  private

  def tackle_params
    params.require(:tackle).permit(:name, :rod, :reel, :line, :bait)
  end
  
  def set_tackle
    @tackle = current_customer.tackles.find(params[:id])
  end
end

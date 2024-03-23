class Public::TacklesController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_tackle, only: [:edit, :update, :destroy]
  before_action :ensure_correct_customer, except: [:index]

  def new
    @tackle = Tackle.new
  end

  def index
    @tackles = current_customer.tackles.order(created_at: :desc).page(params[:page]).per(4)
    @tackle = Tackle.new
  end

  def show
    @tackle = Tackle.find(params[:id])
  end

  def create
    @tackle = current_customer.tackles.build(tackle_params)
    respond_to do |format|
      if @tackle.save
        format.js
        if Post.find_by_id(params[:post_id])
          format.html { redirect_to post_path(params[:post_id]), notice: 'タックルが登録されました' }
        else
          format.html { redirect_to tackles_path, notice: 'タックルが登録されました' }
        end
      else
        format.js 
        format.html { render :new }
      end
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
      render :index
    end
  end

  def destroy
    @tackle = Tackle.find(params[:id])
    @tackle.destroy
    redirect_to tackles_path, notice: 'タックルが削除されました'
  end

  private

  def tackle_params
    params.require(:tackle).permit(:name, tackle_lists_attributes: [:id, :tackle_item_id, :item_name, :_destroy])
  end

  def set_tackle
    @tackle = current_customer.tackles.find(params[:id])
  end

  def ensure_correct_customer
    @tackle = Tackle.find(params[:id])
    unless @tackle.customer == current_customer
      redirect_to posts_path, alert: '権限がありません'
    end
  end

end
class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update]
  before_action :ensure_guest_customer, only: [:edit, :update]

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.posts
    @my_posts = @customer.posts.order(created_at: :desc).page(params[:page]).per(4)
    @post = Post.new
  end

  def index
    @customers = Customer.all
    @post = Post.new
  end

  def edit
    @customer = current_customer
  end

  def update
    if @customer.update(customer_params)
      redirect_to customer_path, notice: "会員情報が更新されました"
    else
      render "edit"
    end
  end

  def confirm
  end

  def withdraw
    @customer = Customer.find(current_customer.id)
    @customer.update(is_deleted: false)
    reset_session
    flash[:notice] = "退会処理が完了しました"
    redirect_to root_path
  end

  private

  def customer_params
    params.require(:customer).permit(:email, :name, :introduction, :image, :favorite_fish, :favorite_rig, :favorite_location)
  end

  def ensure_correct_customer
    @customer = Customer.find(params[:id])
    unless @customer == current_customer
      redirect_to customer_path(current_customer)
    end
  end

  def ensure_guest_customer
    @customer = Customer.find(params[:id])
    if @customer.guest_customer?
      redirect_to customer_path(current_customer), alert: 'ゲストカスタマーはプロフィールを編集できません'
    end
  end
end
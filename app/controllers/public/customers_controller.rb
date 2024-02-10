class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update]

  def show
  @customer = Customer.find(params[:id])
  @books = @customer.books
  @book = Book.new
  end
  
  def index
    @customers = Customer.all
    @book = Book.new
  end

  def edit
    @customer = current_customer
  end

  def update
    if @customer.update(customer_params)
      redirect_to books_path, notice: "アップデートが完了しました"
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
    params.require(:customer).permit(:email, :name, :introduction)
  end

  def ensure_correct_customer
    @customer = Customer.find(params[:id])
    unless @customer == current_customer
      redirect_to customer_path(current_customer)
    end
  end
end

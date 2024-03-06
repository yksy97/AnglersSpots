class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_customer, only: [:retire, :revive]

  def index
    @customers = Customer.all.page(params[:page]).per(20)
  end
  
  def retire
  @customer.update(is_deleted: true)
  redirect_to admin_customers_path, notice: '会員を退会させました'
  end

  def revive
    @customer.update(is_deleted: false)
    redirect_to admin_customers_path, notice: '会員を復活させました'
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end
end
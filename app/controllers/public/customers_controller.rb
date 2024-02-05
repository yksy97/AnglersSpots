# class Public::CustomersController < ApplicationController
#   def show
#     @customer = current_customer
#   end

#   def edit
#     @customer = current_customer
#   end

#   def update
#     @customer = current_customer
#     if @customer.update(customer_params)
#       redirect_to customers_my_page_path(current_customer)
#     else
#       render :root_path
#     end
#   end

#   def confirm
#   end

#   def withdraw
#     @customer = Customer.find(current_customer.id)
#     @customer.update(is_deleted: false)
#     reset_session
#     flash[:notice] = "退会処理が完了しました"
#     redirect_to root_path
#   end

#   private

#   def customer_params
#     params.require(:customer).permit(:email, :name)
#   end
# end

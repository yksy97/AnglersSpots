class Public::RelationshipsController < ApplicationController
  before_action :authenticate_customer!

  def create
    @customer = Customer.find(params[:customer_id])
    current_customer.follow(@customer)
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end
  
 def destroy
    @customer = Customer.find(params[:customer_id])
    current_customer.unfollow(@customer)
    respond_to do |format|
      format.html { redirect_to request.referer }
      format.js
    end
  end
  
  def followings
    customer = Customer.find(params[:customer_id])
    @customers = customer.followings
  end

  def followers
    customer = Customer.find(params[:customer_id])
    @customers = customer.followers
  end
end

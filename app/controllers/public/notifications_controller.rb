class Public::NotificationsController < ApplicationController
  before_action :authenticate_customer!
  
  def index
    @notifications = current_customer.notifications.order(created_at: :desc)
    @favorites = current_customer.posts.order(created_at: :desc).page(params[:page]).per(5)
  end

  def update
    notification = current_customer.notifications.find(params[:id])
    notification.update(read: true)
    redirect_to notification.notifiable_path
  end
end
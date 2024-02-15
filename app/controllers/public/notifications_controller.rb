class Public::NotificationsController < ApplicationController
  before_action :authenticate_customer!

  def update
    notification = current_customer.notifications.find(params[:id])
    notification.update(read: true)
    redirect_to notification.notifiable_path
  end
end
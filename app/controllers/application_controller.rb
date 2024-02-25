class ApplicationController < ActionController::Base
  before_action :search_init
  before_action :favorites_init
  
  def after_sign_in_path_for(resource)
    customer_path(resource)
  end
  
  def search_init
    @q = Post.ransack(params[:q])
  end
  
  def favorites_init
    @favorites = customer_signed_in? ? current_customer.favorites.includes(:post).order(created_at: :desc) : nil
  end
end

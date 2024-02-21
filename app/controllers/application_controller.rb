class ApplicationController < ActionController::Base
  before_action :search_init
  
  def after_sign_in_path_for(resource)
    customer_path(resource)
  end
  
  def search_init
    @q = Post.ransack(params[:q])
  end
end

class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    customer_path(resource)
  end

  before_action :set_search

  def set_search
    @query = { title_or_content_cont: params[:q] }
    @search = Post.ransack(@query)
    @search_posts = @search.result.order(created_at: :desc)
  end
end

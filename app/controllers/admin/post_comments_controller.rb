class Admin::PostCommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @comments = PostComment.all.order('created_at desc')
  end

  def destroy
    comment = PostComment.find(params[:id]).destroy
    redirect_to admin_customer_post_path(comment.post.customer, comment.post_id), notice: 'コメントが削除されました'
  end
end

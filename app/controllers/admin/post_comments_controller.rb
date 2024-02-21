class Admin::PostCommentsController < ApplicationController
  def destroy
    comment = PostComment.find(params[:id]).destroy
    redirect_to admin_customer_post_path(comment.post.customer, comment.post_id)
  end
end

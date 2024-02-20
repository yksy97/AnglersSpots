class Public::PostCommentsController < ApplicationController
  before_action :set_post, only: [:create, :update, :destroy]
  before_action :ensure_correct_customer, only: [:update, :destroy]

  def create
    @comment = current_customer.post_comments.new(post_comment_params.merge(post_id: @post.id))
    if @comment.save
      redirect_to post_path(@post), notice: 'コメントが投稿されました'
    else
      redirect_to post_path(@post), alert: 'コメントの投稿に失敗しました'
    end
  end

  def update
    @comment = @post.post_comments.find(params[:id])
    if @comment.update(post_comment_params)
      redirect_to post_path(@post), notice: 'コメントが更新されました'
    else
      render 'posts/show', alert: 'コメントの更新に失敗しました'
    end
  end

  def destroy
    @comment = @post.post_comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post), notice: 'コメントが削除されました'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def post_comment_params
    params.require(:post_comment).permit(:comment, :parent_id)
  end

  def ensure_correct_customer
    @comment = @post.post_comments.find(params[:id])
    unless @comment.customer == current_customer
      redirect_to post_path(@post), alert: "権限がありません"
    end
  end
end

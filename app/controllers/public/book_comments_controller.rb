class Public::BookCommentsController < ApplicationController
  before_action :set_book, only: [:create, :update, :destroy]
  before_action :ensure_correct_customer, only: [:update, :destroy]

def create
  @comment = current_customer.book_comments.new(book_comment_params.merge(book_id: @book.id))
  if @comment.save
    redirect_to book_path(@book), notice: '感想が投稿されました'
  else
    redirect_to book_path(@book), alert: '感想の投稿に失敗しました'
  end
end


def update
  @comment = @book.book_comments.find(params[:id])
  respond_to do |format|
    if @comment.update(book_comment_params)
      format.js { flash.now[:notice] = '感想が更新されました' }
    else
      format.js { flash.now[:alert] = '感想の更新に失敗しました' }
    end
  end
end

def destroy
  @comment = @book.book_comments.find(params[:id])
  respond_to do |format|
  if @comment.destroy
     format.js
    end
  end
end

   private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

  def ensure_correct_customer
    @comment = @book.book_comments.find(params[:id])
    unless @comment.customer == current_customer
      redirect_to book_path(@book), alert: "権限がありません"
    end
  end
end
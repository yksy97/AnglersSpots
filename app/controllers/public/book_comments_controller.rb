class Public::BookCommentsController < ApplicationController
  before_action :set_book, only: [:create, :update, :destroy]

  def create
  @comment = current_customer.book_comments.new(book_comment_params.merge(book_id: @book.id))
  if @comment.save
    respond_to do |format|
      format.js
    end
  end
end

def update
  @comment = @book.book_comments.find(params[:id])
  if @comment.update(book_comment_params)
    respond_to do |format|
      format.js
    end
  end
end

def destroy
  @comment = @book.book_comments.find(params[:id])
  if @comment.destroy
    respond_to do |format|
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
end

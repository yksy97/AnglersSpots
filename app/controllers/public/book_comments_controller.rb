class Public::BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @comment = current_customer.book_comments.new(book_comment_params)
    @comment.book_id = @book.id
    if @comment.save
      redirect_to book_path(@book), notice: 'Comment was successfully created.'
    else
      render 'public/books/show'
    end
  end

  def destroy
    @comment = BookComment.find_by(id: params[:id], book_id: params[:book_id])
    @comment.destroy
    redirect_to book_path(params[:book_id]), notice: 'Comment was successfully destroyed.'
  end

  private
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end


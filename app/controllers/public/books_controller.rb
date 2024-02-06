class Public::BooksController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def index
    @q = Book.ransack(params[:q])
    @books = @q.result(distinct: true)
    @book = Book.new
  end
  

   def create
    @book = current_customer.books.new(book_params)
    respond_to do |format|
      if @book.save
        format.html { redirect_to books_path, notice: "投稿が成功しました。" }
        format.js
      else
        @books = Book.all
        format.html { render 'index' }
        format.js { render 'errors' } # エラー処理用のJSビューを追加
      end
    end
  end



  def edit
  end
  
  def genre
    genre = Genre.find(params[:id])
    @books = genre.books
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.customer == current_customer
      redirect_to books_path
    end
  end
end

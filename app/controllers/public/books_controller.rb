class Public::BooksController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    @book_comments = @book.book_comments.order(created_at: :desc)
  end

 def index
  @q = Book.ransack(params[:q])
  @books = @q.result(distinct: true).order(created_at: :desc)
  @book = Book.new
end

  
def create
  @book = Book.new(book_params)
  @book.customer_id = current_customer.id
  if @book.save
    redirect_to books_path, notice: "投稿が完了しました"
end
end


  def genre
    genre = Genre.find(params[:id])
    @books = genre.books
  end

  def edit
    @book = Book.find(params[:id])
  end

def update
  if @book.update(book_params)
    redirect_to book_path(@book), notice: "本の登録情報が更新されました."
  else
    render :edit
  end
end


def destroy
  @book.destroy
  redirect_to books_path, notice: "本が削除されました"
end


  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_customer
    @book = Book.find(params[:id])
    unless @book.customer == current_customer
      redirect_to books_path, alert: '権限がありません。'
    end
  end
end

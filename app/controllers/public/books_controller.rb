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
  # respond_toブロックといえば、formatメゾット
  # formatメゾットで特定のリクエスト形式（htmlやjs、json）に対する具体的な処理を記述する
  # respond_toブロックはformatメゾットによって異なるリクエスト形式に対する応答を処理する
  respond_to do |format|
    if @book.save
      format.html { redirect_to books_path, notice: "投稿が完了しました" }
        # 「.all」は「N+1問題」が生じる可能性がある。
        # 今後、ジャンル情報を本に紐づける場合は、「includes」メゾットを使う
      format.js { @books = Book.all }
    else
      format.html { redirect_to books_path, alert: "投稿に失敗しました" }
      format.js { @books = Book.all }
    end
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
  respond_to do |format|
    if @book.update(book_params)
      format.html { redirect_to book_path(@book), notice: "本の登録情報が更新されました." }
      format.js
    else
      format.html { render "edit" }
      format.js
    end
  end
end

def destroy
  @book.destroy
  respond_to do |format|
    format.html { redirect_to books_path, notice: "本が削除されました" }
    format.js
  end
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

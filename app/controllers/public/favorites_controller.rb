class Public::FavoritesController < ApplicationController
def create
  book = Book.find(params[:book_id])
  @favorite = current_customer.favorites.new(book_id: book.id)
  @favorite.save
  respond_to do |format|
    # redirect_to book_path(book)の部分は後から変更、ボタンを設置した場所にリダイレクトするようにする
    format.html { redirect_to book_path(book) }  # リダイレクト先を本の詳細ページに設定
    format.js   # create.js.erb を呼び出す
  end
end

def destroy
  book = Book.find(params[:book_id])
  @favorite = current_customer.favorites.find_by(book_id: book.id)
  @favorite.destroy
  respond_to do |format|
    # 非同期通信がうまくいかなかった時の代替措置
     # redirect_to book_path(book)の部分は後から変更、ボタンを設置した場所にリダイレクトするようにする
    format.html { redirect_to book_path(book) }  # リダイレクト先を本の詳細ページに設定
    format.js   # destroy.js.erb を呼び出す
  end
end
end
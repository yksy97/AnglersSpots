class Public::FavoritesController < ApplicationController
def create
  post = Post.find(params[:post_id])
  @favorite = current_customer.favorites.new(post_id: post.id)
  @favorite.save
  respond_to do |format|
    # redirect_to book_path(book)の部分は後から変更、ボタンを設置した場所にリダイレクトするようにする
    format.html { redirect_to post_path(post) }  # リダイレクト先を本の詳細ページに設定
    format.js   # create.js.erb を呼び出す
  end
end

def destroy
  post = Post.find(params[:post_id])
  @favorite = current_customer.favorites.find_by(post_id: post.id)
  @favorite.destroy
  respond_to do |format|
    # 非同期通信がうまくいかなかった時の代替措置
     # redirect_to book_path(book)の部分は後から変更、ボタンを設置した場所にリダイレクトするようにする
    format.html { redirect_to post_path(post) }  # リダイレクト先を本の詳細ページに設定
    format.js   # destroy.js.erb を呼び出す
  end
end
end
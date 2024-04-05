class Public::PostsController < ApplicationController
  before_action :authenticate_customer!
  before_action :ensure_correct_customer, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
    @genres = Genre.order(:name)
    @tackles = Tackle.all
  end

  def index
    if params[:rig_id]
      @posts = Rig.find(params[:rig_id]).posts.includes(:customer).order(created_at: :desc).page(params[:page]).per(6)
    elsif params[:location]
      @posts = Post.where(location: params[:location]).includes(:customer).order(created_at: :desc).page(params[:page]).per(6)
    elsif params[:genre_name]
      @posts = Post.where(genre_name: params[:genre_name]).includes(:customer).order(created_at: :desc).page(params[:page]).per(6)
    else
      @posts = Post.includes(:customer).order(created_at: :desc).page(params[:page]).per(6)
    end
    @post = Post.new
    @genres = Genre.order(:name)
    @tackles = Tackle.all
  end

  def show
    @post = Post.find(params[:id])
    @customer = @post.customer
    @post_comment = PostComment.new
    @post_comments = @post.post_comments.order(created_at: :desc)
  end

  def create
    @post = current_customer.posts.build(post_params)
    if params[:post][:new_genre_name].present?
      genre = Genre.find_or_create_by(name: params[:post][:new_genre_name], customer_id: current_customer.id )
      @post.genre_name = genre.name
    end
    respond_to do |format|
      if @post.save
        @post.save_rigs(params[:post][:rig_list])
        format.html { redirect_to posts_path, notice: "投稿が完了しました" }
        format.js
      else
        format.html { redirect_to posts_path, alert: "投稿が失敗しました" }
        format.js
      end
    end
  end

  def genre
    genre = Genre.find(params[:id])
    @posts = genre.posts
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "投稿が更新されました"
    else
      render :edit
    end
  end

  def tackle_selection
    @post = Post.find(params[:id])
    if @post.update(tackle_id: params[:post][:tackle_id])
      redirect_to @post, notice: '登録したタックルが適用されました'
    else
      render :edit, alert: '登録したタックルの適用に失敗しました'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "投稿が削除されました"
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image, :genre_name, :location, :tackle_id, :rig_list)
  end

  def ensure_correct_customer
    @post = Post.find(params[:id])
    unless @post.customer == current_customer
      redirect_to posts_path, alert: '権限がありません'
    end
  end
end



# 勉強メモ
# 投稿の作成から保存までの流れ
# posts/index.html.erbからPosts/_NewPostModal.html.erbのフォームを通して投稿される。
# フォームを入力し、Customerが送信ボタンを押すと、createアクションへリクエストが送られ、処理が開始される。
# 34行目「@post = current_customer.posts.build(post_params)」では、
# -「current_customer.posts.build」メソッドを使用して、現在ログインしているCustomerに関連付けられた新しいPostインスタンスを作成する。「build」メソッドは、関連付けられたオブジェクトの新しいインスタンスをメモリ上に作成する役割を持つ。
# -「post_params」（ストロングパラメータ）を引数として「build」メソッドに渡すことで、新しいPostインスタンスの属性をフォームから送信されたデータで初期化する。ここでの「初期化」とは、インスタンスの各属性に値を設定すること。
# - ストロングパラメータである「post_params」メソッドは、コントローラーで明示的に許可された属性（:title, :body, :image, :genre_name, :location, :tackle_id, :rig_list）のみが新しいPostインスタンスに設定されるようにする。
# これにより、不正なデータや意図しないデータの変更を防ぎ、アプリケーションの安全性を高める。

# buildメソッドとnewメソッドの違いについて
# どちらもインスタンスを作成するメソッドだが、使用する場面が異なる。

# - newメソッド:
#   単にモデルの新しいインスタンスを作成する場合に使用する。
#   関連付ける他のモデルがない場合や、単純なインスタンスの作成のみを目的とする時に適している。
#   例: @post = Post.new(post_params)

# - buildメソッド:
#   特定のモデルのインスタンスを作成する際に、他のモデルとの関連付けを同時に行いたい場合（今回は、「Customer」モデルと「Post」モデル）に使用する。
#   1対多（one-to-many）や多対多（many-to-many）の関連があるモデル間で、関連するオブジェクトのインスタンスを作成する時に便利。
#   例: @post = current_customer.posts.build(post_params)
#   この例では、current_customer（「Customer」インスタンス）に紐づく新しいPostインスタンスを作成し、そのインスタンスにpost_paramsで初期化する。
#   buildメソッドは、関連するモデル間のキーを自動的に設定するため、関連付けが必要な場面で便利。

# buildメソッドのまとめ
# 親が 「Customer」で、子が「Post」で、特定の「Customer」の投稿を作成する場合に 「build」メソッドを使う。
# これにより、作成される Post インスタンスは、自動的にその Customer（親）に関連付けられる。
# この関連付けにより、投稿がどのユーザー（顧客）によって作成されたかが明確になり、データベース内での関係を維持することができる。

# 35行目「 if params[:post][:new_genre_name].present?」は、新規の魚種（new_genre_name）が入力されて何らかの値を所持しているか確認する。
# genre = Genre.find_or_create_by(name: params[:post][:new_genre_name], customer_id: current_customer.id )で、送信された新規の魚種がすでにGenreモデルのデータベースに存在するか確認して、存在しなければ、新しい魚種としてデータベースに保存する。
# @post.genre_name = genre.nameは、投稿フォームから送信された新規か既存の魚種を、現在作成している投稿（＠post）の「genre_name」属性に設定する。これで、特定の魚種が投稿に関連付けられる。

#  if @post.save
#　@post.save_rigs(params[:post][:rig_list])
# ここで、作成されたPostをデータベースに保存し、成功すれば追加でRigsのデータも保存する。

# 44行目以降のelseブロック
#  else
      #   @posts = Post.includes(:customer, :genre).order(created_at: :desc).page(params[:page]).per(6)
      #   @my_posts = current_customer.posts.order(created_at: :desc).page(params[:page]).per(6)
      #   @genres = Genre.order(:name)
      #   @tackles = Tackle.all
      #   format.html { render :index }
      #   format.js
      # end
      
# 保存が失敗したとき、変数を使って再描画する処理になってるけど、ただ「format.html { redirect_to posts_path, alert: "投稿が失敗しました" }」でもよさそう。
#   else
  #   format.html { redirect_to posts_path, alert: "投稿が失敗しました" }
  #   format.js
  # end
class Public::GenresController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_genre, only: [:edit, :update, :destroy]

  def index
    @genres = current_customer.genres.order(created_at: :desc).page(params[:page]).per(20)
    @genre = current_customer.genres.new
  end

  def create
    @genre = current_customer.genres.new(genre_params)
    if @genre.save
      redirect_to genres_path, notice: '新しい魚が登録されました'
    else
      @genres = current_customer.genres.order(:name).page(params[:page]).per(20)
      render :index
    end
  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      redirect_to genres_path, notice: '魚が更新されました'
    else
      @genres = Genre.all
      render :index
    end
  end

  def destroy
    @genre.destroy
    redirect_to genres_path, notice: '魚が削除されました'
  end

  private

  def set_genre
    @genre = current_customer.genres.find(params[:id])
  end

  def genre_params
    params.require(:genre).permit(:name)
  end
end



# 勉強メモ
# before_action :authenticate_customer!は、「authenticate_customer!」メソッドでユーザーがログインしているかチェックして、ログインしている場合に「edit,update,destroy」アクションが実行できる。
# ここでの「！」の役割は、device機能においてユーザーが未承認の場合に、ログインページへリダイレクトする働きがある。
# 「！」をメソッドの末尾につけるかの基準は、認証チェックのように、セキュリティ上重要な操作（オブジェクト自身を変更する破壊的な操作）を行うかによる。

# ストロングパラメータはRailsの機能
# genre_paramsメソッドを通じて、許可されたパラメータのみをモデルに渡すことで、不正なマスアサインメントを防ぐ。

# カプセル化はオブジェクト指向の考え方
# set_genreやgenre_paramsメソッドをprivateとして宣言することで、これらのメソッドがコントローラの外部から直接呼び出されないようにする
# このようにしてカプセル化を実現し、コントローラの内部実装を隠蔽する

# リファクタリング
# set_genreメソッドのように共通の処理をメソッドとしてまとめることで、コードの重複を避け、可読性と再利用性を向上

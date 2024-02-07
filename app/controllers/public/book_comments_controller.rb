class Public::BookCommentsController < ApplicationController
  
  def index
    @book = Book.find(params[:book_id])
    # Rails「includes」メゾットを使って、RDSで一般的な「N＋１問題」を防ぐ。
    # 「N+1問題」とは、一覧画面の表示ようなループ処理の中でレコードに対応する関連レコードを取得するために、本来1回のクエリで済むところを、ループの回数分だけクエリが発行されてしまい、結果としてレスポンス速度や処理効率が低下する問題
    # 「includes」メゾットを使って、book_comments を読み込む際に、それぞれの book_comment に紐づく customer の情報も同時に事前に読み込んでおくことで処理効率の低下を防ぐ
    @comments = @book.book_comments.includes(:customer)
  end
  
  def create
    @book = Book.find(params[:book_id])
    @comment = current_customer.book_comments.new(book_comment_params)
    @comment.book_id = @book.id
    if @comment.save
      redirect_to book_path(@book), notice: '感想の投稿が完了しました'
    else
      @book_comments = @book.book_comments
      render 'public/books/show'
    end
  end
  
  def edit
  end

  def update
    if @book_comment.update(book_comment_params)
      redirect_to book_path(@book_comment.book), notice: '感想の更新が完了しました'
    else
      render :edit
    end
  end

  def destroy
    @comment = BookComment.find_by(id: params[:id], book_id: params[:book_id])
    if @comment.destroy
      redirect_to book_path(params[:book_id]), notice: '感想の削除が完了しました'
    else
      redirect_to book_path(params[:book_id]), alert: '感想の削除に失敗しました'
    end
  end

  private
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end

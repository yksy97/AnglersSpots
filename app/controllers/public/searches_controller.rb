class Public::SearchesController < ApplicationController
  def search
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).page(params[:page]).per(5)
    @post = Post.new
    @tackles = Tackle.all
  end
end

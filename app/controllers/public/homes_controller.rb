class Public::HomesController < ApplicationController
  before_action :redirect_if_authenticated, only: [:top]
  
  def top
    
  end
  
  def about
  end


  private

# ログイン済みの会員がトップページに遷移できないようにする
  def redirect_if_authenticated
    redirect_to posts_path if customer_signed_in?
  end
end

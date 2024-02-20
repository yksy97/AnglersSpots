Rails.application.routes.draw do
  
  # get 'genres/index'
  # get 'genres/create'
  
  
  # 顧客用Deviseルーティング
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }
  
  # ゲストログイン用のルーティングを追加
  devise_scope :customer do
    post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in', as: :guest_customer_session
  end

  # 管理者用Deviseルーティング
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

scope module: :public do
  root to: 'homes#top'
  get 'about', to: 'homes#about'

  # confirmとwithdrawはcustomerブロックの外側に。退会処理に特定のIDは必要ないため。
  get "customers/confirm" => "customers#confirm"
  patch "customers/withdraw" => "customers#withdraw"
  
  resources :customers, only: [:show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :posts, only: [:new, :index, :show, :edit, :create, :destroy, :update] do
    resources :post_comments, only: [:create, :edit, :destroy, :update]
    resource :favorites, only: [:create, :destroy]
    member do
      patch 'tackle_selection', to: 'posts#tackle_selection'
    end
  end

  resources :notifications, only: [:index]

  resources :genres, only: [:index, :create, :edit, :update, :destroy] do
    get 'posts', to: 'posts#genre', as: 'posts', on: :member
  end
  
  resources :tackles, only: [:new, :create, :index, :edit, :update, :destroy]
end
end
Rails.application.routes.draw do
  get 'genres/index'
  get 'genres/create'
  # 顧客用Deviseルーティング
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

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

  resources :posts, only: [:index, :show, :edit, :create, :destroy, :update] do
    resources :post_comments, only: [:create, :edit, :destroy, :update]
    resource :favorites, only: [:create, :destroy]
    collection do
      # 「ransack」 matchメゾット、viaオプションでGETとPOSTを指定
      match 'search' => 'posts#search', via: [:get, :post], as: :search
    end
  end

  resources :notifications, only: [:index]

  resources :genres, only: [:index, :create, :edit, :update, :destroy] do
    get 'posts', to: 'posts#genre', as: 'posts', on: :member
  end
  
  resources :tackles, only: [:new, :create, :index, :edit, :update, :destroy]
end
end
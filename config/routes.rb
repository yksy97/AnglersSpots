Rails.application.routes.draw do
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

    resources :books, only: [:index, :show, :edit, :create, :destroy, :update] do
      resources :book_comments, only: [:index, :create, :destroy]
      resource :favorites, only: [:create, :destroy]
      collection do
        # 「ransack」 matchメゾット、viaオプションでGETとPOSTを指定
        match 'search' => 'books#search', via: [:get, :post], as: :search
      end
    end

    resources :genres, only: [] do
      get 'books', to: 'books#genre', as: 'books', on: :member
    end
  end
end

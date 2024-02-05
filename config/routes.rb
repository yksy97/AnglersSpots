Rails.application.routes.draw do
  # 顧客DEVISE
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  # 管理者DEVISE
  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  # public名前空間内のルーティング
  scope module: :public do
    root to: 'homes#top'
    get 'about', to: 'homes#about'
    
    resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
    end
   
    resources :customers, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
  	get 'followings' => 'relationships#followings', as: 'followings'
  	get 'followers' => 'relationships#followers', as: 'followers'
    end
  # get '/search', to: 'searches#search'
    end
end

  
  
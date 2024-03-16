Rails.application.routes.draw do
  devise_scope :customer do
    post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in', as: :guest_customer_session
    get 'customers', to: 'public/registrations#new'
  end

  devise_scope :admin do
    post 'admins/guest_sign_in', to: 'admin/sessions#guest_sign_in', as: :guest_admin_session
  end

  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    resources :customers, only: [:index] do
      member do
        patch :retire
        patch :revive
      end
      resources :posts, only: [:index, :show, :destroy] do
        resources :post_comments, only: [:index, :destroy]
      end
    end

    resources :genres, only: [:index, :destroy]

    resources :tackles, only: [:index, :show, :destroy]

    resources :post_comments, only: [:index, :destroy]
  end

  devise_for :customers, skip: [:passwords], controllers: {
  registrations: 'public/registrations',
  sessions: 'public/sessions'
  }

  scope module: :public do
    root to: 'homes#top'
    get 'about', to: 'homes#about'

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

    resources :favorites, only: [:index]

    resources :notifications, only: [:index]

    resources :genres, only: [:index, :create, :edit, :update, :destroy] do
      get 'posts', to: 'posts#genre', as: 'posts', on: :member
    end

    resources :tackles, only: [:new, :create, :index, :show, :edit, :update, :destroy]
      get '/searches', to: 'searches#search'
      get 'tides/graf', to: 'tides#graf'
      get 'tides/get_port_name', to: 'tides#get_port_name'
    resources :tides, only: [:index]
  end
end
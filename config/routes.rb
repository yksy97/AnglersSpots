Rails.application.routes.draw do
  
devise_for :users,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

devise_scope :guest do
    post "guests/guest_sign_in", to: "guests/sessions#guest_sign_in"
  end




end

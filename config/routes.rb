Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'posts#index'
  get 'about', to: 'about#index'
  get 'admin', to: 'posts#admin'
  resources :posts
  
end

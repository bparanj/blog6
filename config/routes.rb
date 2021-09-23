Rails.application.routes.draw do
  resources :articles do
    resources :comments
  end
  
  resources :users
  resource :session

  get '/login', to: 'sessions#new', as: 'login'
  get '/logout', to: 'sessions#destroy', as: 'logout'
  
  root to: "articles#index"
end

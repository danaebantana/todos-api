Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'signup', to: 'users#create'

  post 'auth/login', to: 'authentication#authenticate'
  get 'auth/logout', to: 'authentication#destroy'

  resources :todos do
    resources :items
  end
end

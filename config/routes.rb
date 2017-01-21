Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'static_pages#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :articles, only: [:index, :show]
  resources :categories, only: [:show]

  namespace :admin do
    get 'dashboard' => 'dashboard#index'
    resources :articles do
      resources :sections
    end
    resources :categories
    get 'profile' => 'profiles#edit'
    patch 'update_email' => 'profiles#update_email'
    post 'update_password' => 'profiles#update_password'
  end
end

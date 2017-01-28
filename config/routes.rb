Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'articles#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'about' => 'abouts#show'

  resources :articles, only: [:index, :show]
  resources :categories, only: [:show]

  namespace :admin do
    get 'dashboard' => 'dashboard#index'
    resources :articles do
      resources :sections
    end
    resources :categories
    resource :about
    get 'profile' => 'profiles#edit'
    patch 'update_email' => 'profiles#update_email'
    post 'update_password' => 'profiles#update_password'
  end

  match "/404", :to => 'errors#error_404', via: :all

  get '*url' => 'errors#error_404'
end

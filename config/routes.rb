Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'static_pages#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  namespace :admin do
    get 'dashboard' => 'dashboard#index'
    resources :articles
    get 'profile' => 'profiles#edit'
    post 'update_password' => 'profiles#update_password'
  end
end

Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  devise_for :users, as: :client, path: 'client', controllers: {
    sessions: 'client/users/sessions'
  }

  # Routes for admin authentication
  devise_for :users, as: :admin, path: 'admin', controllers: {
    sessions: 'admin/users/sessions'
  }

  namespace :admin do
    root "home#index"
  end

  namespace :client do
    root "home#index"
  end
end

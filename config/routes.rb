Rails.application.routes.draw do

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # Routes for admin authentication

  constraints(AdminDomainConstraint.new) do
    namespace :admin do
      root "home#index"
      resources :items, except: :show do
        member do
          post 'start'
          post 'pause'
          post 'end'
          post 'cancel'
        end
      end
      resources :categories, except: :show
      resources :tickets, only: :index do
        member do
          post 'cancel'
        end
      end
    end

    devise_for :users, as: :admin, path: 'admin', controllers: {
      sessions: 'admin/users/sessions'
    }, skip: [:registrations]
  end

  constraints(ClientDomainConstraint.new) do
    namespace :client do
      root "home#index"
      resources :me, only: [:index]
      resources :invite, only: [:index], constraints: {}
      resources :addresses
      resources :lottery, only: [:index, :show]
    end

    devise_for :users, as: :client, path: 'client', controllers: {
      sessions: 'client/users/sessions',
      registrations: 'client/users/registrations'
    }
  end

  resources :menu, only: :index

  namespace :api do
    namespace :v1 do
      resources :regions, only: [:index, :show] do
        resources :provinces, only: :index
      end

      resources :provinces, only: [:index, :show] do
        resources :cities, only: :index
      end

      resources :cities, only: [:index, :show] do
        resources :barangays, only: :index
      end

      resources :barangays, only: [:index, :show]
    end
  end
end

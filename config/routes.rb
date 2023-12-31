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
      resources :winners, only: :index do
        member do
          post 'submit'
          post 'pay'
          post 'ship'
          post 'deliver'
          post 'publish'
          post 'remove_publish'
        end
      end
      resources :offers, except: :show
      resources :orders, only: :index do
        member do
          post 'pay'
          post 'cancel'
        end
      end
      resources :users, only: :index, path: 'users/client' do
        namespace :admin_orders, path: 'orders'  do
          resources :increase, only: [:new, :create]
          resources :deduct, only: [:new, :create]
          resources :bonus, only: [:new, :create]
          resources :member_levels, only: [:new, :create]
        end
      end
      resources :invites, only: :index
      resources :news_tickers, except: :show
      resources :banners, except: :show
      resources :member_levels, except: :show
    end

    devise_for :users, as: :admin, path: 'admin', controllers: {
      sessions: 'admin/users/sessions'
    }, skip: [:registrations]
  end

  constraints(ClientDomainConstraint.new) do
    namespace :client do
      root 'home#index'
      resources :menu, only: :index
      resources :me, only: [:index, :show, :update] do
        member do
          patch 'me/update_winners'
          post 'cancel'
        end
      end
      resources :invite, only: [:index], constraints: {} do
        patch 'update_member_level_basic_1', on: :member
        patch 'update_member_level_standard', on: :member
        patch 'update_member_level_premium', on: :member
        patch 'update_member_level_silver', on: :member
        patch 'update_member_level_gold', on: :member
      end
      resources :addresses
      resources :lottery, only: [:index, :show, :create]
      resources :shop, only: [:index, :show, :create]
      resources :share, only: [:index, :show, :update] do
        member do
          post 'share'
        end
      end
    end

    devise_for :users, as: :client, path: 'client', controllers: {
      sessions: 'client/users/sessions',
      registrations: 'client/users/registrations'
    }
  end

  resources :users do
    post 'update_member_level', on: :member
  end

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

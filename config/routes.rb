Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  scope "(:locale)", locale: /en/ do
    devise_for :users, skip: [:sessions, :omniauth_callbacks], controllers: { registrations: "users/registrations" }
    as :user do
      post "/sign_in" => "devise/sessions#create", :as => :user_session
      delete "/sign_out" => "devise/sessions#destroy", :as => :destroy_user_session
    end

    root "pages#index"

    if Rails.application.config.enable_sign_in_as
      get 'login_as', to: "sessions#login_as"
    end

    namespace :backend do
      resources :users

      resources :leave_applications, except: [:show, :destroy] do
        get :verify, on: :member
        get :statistics, on: :collection
      end

      resources :leave_times, except: [:edit, :update, :destroy] do
        post :append_quota, on: :collection
        get :batch_new, on: :collection
        post :batch_create, on: :collection
      end

      resources :overtimes, except: [:show, :destroy] do
        get :verify, :add_leave_time, :add_compensatory_pay, on: :member
        post :create_leave_time, :create_compensatory_pay, on: :member
        get :statistics, on: :collection
      end

      resources :bonus_leave_time_logs, only: [:index, :update]
    end

    resources :leave_applications, except: [:destroy] do
      member do
        put "cancel"
      end

      collection do
        get "/:status", to: "leave_applications#index",
                        constraints: { status: /pending|approved|rejected|canceled/ }
      end
    end

    resources :leave_times, only: [:index, :show]
    resources :remote, only: [:new, :create, :update, :edit]

    resources :overtimes, except: :destroy do
      member do
        put "cancel"
      end
    end

  end
end

HoursReport::Application.routes.draw do

  class XHRConstraint
    def matches?(request)
      !request.xhr? && !(request.url =~ /\.json$/ && ::Rails.env == 'development') && (request.url =~ /users\/\d+\/expense_reports\//)
    end
  end

  get '/users/:user_id/expense_reports*path' => 'expense_reports#index', :constraints => XHRConstraint.new

  root 'users#show'
  concern :the_role, TheRole::AdminRoutes.new

  namespace :admin do
    concerns :the_role
  end

  resources :invitations,       only: [:new, :create]
  resources :users,             only: [:index, :show] do
    resources :timesheets,      only: [:edit, :update, :index]
    resources :expense_reports, only: [:index]
  end

  match "users/all" => "users#update_all", :as => :update_all, :via => :put

  resources :reports,        only: [:index, :show, :new, :create, :destroy, :update] do
    resources :timesheets,   only: [:edit, :update, :index]
    resources :reminders,    only: [:create]
  end

  match '/auth/:provider/callback' => 'sessions#create', via: %i(get post)
  match '/logout'                  => 'sessions#destroy', via: %i(get delete), as: :logout
  match '/login'                   => 'sessions#new', via: %i(get), as: :login

  mount Sidekiq::Web => '/sidekiq'

  namespace :api, :defaults => { :format => :json } do
    namespace :v1 do
      resources :expenses
      resources :expense_reports do
        resources :expenses
      end
    end
  end
end

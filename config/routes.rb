HoursReport::Application.routes.draw do
  root 'users#show'
  concern :the_role, TheRole::AdminRoutes.new

  namespace :admin do
    concerns :the_role
  end

  resources :invitations,    only: [:new, :create]
  resources :users,          only: [:index, :show] do
    resources :timesheets,   only: [:edit, :update, :index]
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
end

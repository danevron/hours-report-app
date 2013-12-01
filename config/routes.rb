HoursReport::Application.routes.draw do

  root 'users#show'

  resources :invitations,    only: [:new, :create]
  resources :users,          only: [:index, :show] do
    resources :timesheets,   only: [:edit, :update, :index]
  end

  resources :reports,        only: [:index, :show, :new, :create, :destroy] do
    resources :timesheets,   only: [:edit, :update, :index]
  end

  match '/auth/:provider/callback' => 'sessions#create', via: %i(get post)
  match '/logout'                  => 'sessions#destroy', via: %i(get delete), as: :logout
  match '/login'                   => 'sessions#new', via: %i(get), as: :login
end

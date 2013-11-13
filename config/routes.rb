HoursReport::Application.routes.draw do

  resources :invitations, only: [:new, :create]
  resources :users, only: [:index, :show]
  root 'users#show'

  match '/auth/:provider/callback' => 'sessions#create', via: %i(get post)
  match '/logout' => 'sessions#destroy', via: %i(get delete), as: :logout
  match '/login' => 'sessions#new', via: %i(get), as: :login
end

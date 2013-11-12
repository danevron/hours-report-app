HoursReport::Application.routes.draw do

  resources :invitations, only: [:create]
  resources :employees, only: [:index, :show]
  root 'employees#show'

  match '/auth/:provider/callback' => 'sessions#create', via: %i(get post)
  match '/logout' => 'sessions#destroy', via: %i(get delete), as: :logout
  match '/login' => 'sessions#new', via: %i(get), as: :login
end

Rails.application.routes.draw do

  resources :uploads
  root 'static_pages#home'
  get '/browse', to: 'static_pages#browse'
  get '/upload', to: 'uploads#index'
  get '/query', to: 'static_pages#home'

  # Users
  # Using Devise RegistrationsController for public user creation/registration.
  devise_for :users, controllers: { registrations: 'registrations' }
  # Using UsersController and /users/* paths for profile viewing and editing.
  resources :users, only: [:show, :edit, :update]
  # Namespacing to the '/admin/users' path, to avoid conflicting with Devise.
  scope 'admin' do
    resources :users, only: [:index, :new, :create, :destroy]
  end

end

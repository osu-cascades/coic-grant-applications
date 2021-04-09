Rails.application.routes.draw do

  get 'notes/index'
  get 'notes/show'
  get 'notes/edit'
  get 'notes/new'
  resources :queries
  resources :owners
  resources :applications
  resources :companies do 
    collection { post :import }
  end
  
  resources :uploads
  root 'queries#show'
  get '/browse', to: 'companies#index'
  get '/upload', to: 'uploads#index'
  get '/query', to: 'queires#show'
  get '/company', to: 'companies#index'

  get '/new_query', to: 'static_pages#home'
  get '/download.csv', to: 'uploads#download'
  get '/exportquery.csv', to: 'queries#export'

  #match 'DownloadHeader', to: 'home#DownloadHeader', as: 'DownloadHeader', via: :get
  
  # Users
  # Using Devise RegistrationsController for public user creation/registration.
  devise_for :users
  # Using UsersController and /users/* paths for profile viewing and editing.
  resources :users, only: [:show, :edit, :update]
  # Namespacing to the '/admin/users' path, to avoid conflicting with Devise.
  scope 'admin' do
    resources :users, only: [:index, :new, :create, :destroy]
  end

end

Rails.application.routes.draw do

  root to: 'welcome#index'

  get :welcome, to: 'welcome#index'

  scope :auth do
    get :sign_up, to: 'users#new'

    get :sign_in, to: 'session#new'
    post :sign_in, to: 'session#create'
    get :sign_out, to: 'session#destroy'

    get 'password/new', to: 'password#new', as: :new_password
    post :password, to: 'password#create'
    get 'password/edit', to: 'password#edit', as: :edit_password
    put :password, to: 'password#update'
  end

  resources :users, except: [:index, :destroy]

  namespace :admin do
    resources :users, except: [:new, :create, :show]
    resources :roles, except: [:new, :show]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

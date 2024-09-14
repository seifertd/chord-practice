Rails.application.routes.draw do
  resources :shits
  get 'static_pages/home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:index, :show, :create, :destroy, :update]
  resources :progress, only: [:index]
  root 'static_pages#home'
  resource :chords, only: [:show, :update]
end

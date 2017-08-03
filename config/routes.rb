Rails.application.routes.draw do
  get 'static_pages/home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:index, :show, :create, :destroy, :update]
  root 'static_pages#home'
  resource :chords, only: [:show, :update]
end

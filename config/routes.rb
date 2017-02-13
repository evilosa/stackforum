Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  devise_for :users
  resources :questions do
    resources :answers
    patch 'update_body'
  end

  root to: 'questions#index'
end

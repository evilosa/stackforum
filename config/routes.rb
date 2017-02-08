Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  devise_for :users
  resources :questions do
    resource :answers, shallow: true
  end

  root to: 'questions#index'
end

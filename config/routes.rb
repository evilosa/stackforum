Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  devise_for :users
  resources :questions do
    resources :answers
    patch 'update_body', on: :member
    patch 'best_answer', on: :member
  end

  resources :attachments, only: [:destroy]

  root to: 'questions#index'
end

Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  concern :votable do
    member do
      patch :upvote
      patch :downvote
    end
  end

  devise_for :users
  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable]
    patch 'update_body', on: :member
    patch 'best_answer', on: :member
  end

  resources :attachments, only: [:destroy]

  root to: 'questions#index'
end

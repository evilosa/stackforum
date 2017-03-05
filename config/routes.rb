Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  concern :votable do
    member do
      patch :upvote
      patch :downvote
    end
  end

  concern :commentable do
    member do
      post :comment
      patch :edit_comment
    end
  end

  devise_for :users
  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable]
    patch 'update_body', on: :member
    patch 'best_answer', on: :member
  end

  resources :attachments, only: [:destroy]

  root to: 'questions#index'
end

Rails.application.routes.draw do
  use_doorkeeper
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

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable]
    patch 'update_body', on: :member
    patch 'best_answer', on: :member
  end

  resources :attachments, only: [:destroy]

  resource :omniauth, only: [:show] do
    post 'update_email', on: :member
    get 'confirm_email', on: :member
  end

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
      end
    end
  end

  root to: 'questions#index'
end

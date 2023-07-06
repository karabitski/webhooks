# frozen_string_literal: true

Rails.application.routes.draw do
  resources :organizations, only: %i[show] do
    resources :projects, only: %i[index create show update destroy]
    resources :users, only: %i[create]
  end

  resources :projects, only: [] do
    resources :tasks, only: %i[index create show update destroy]
  end

  resources :sessions, only: %i[create]
  delete '/logout', to: 'sessions#destroy'
end

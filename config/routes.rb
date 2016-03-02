Rails.application.routes.draw do
  root "static_pages#home"
  devise_for :users
  resources :journal_entries
  resources :chart_of_accounts
  resources :log_books

  namespace :api, defaults: {format: "json"} do
    devise_for :users, only: :session
    scope module: :v1 do
      resources :users, only: [:index]
    end
  end
end

Rails.application.routes.draw do
  root "static_pages#home"
  devise_for :users
  resources :journal_entries
  resources :chart_of_accounts
  resources :log_books
end

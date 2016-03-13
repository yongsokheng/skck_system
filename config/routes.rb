Rails.application.routes.draw do
  root "static_pages#home"
  devise_for :users
  resources :journal_entries
  resources :chart_of_accounts
  resources :log_books
  resources :item_lists
  resources :close_working_periods, only: :create
  resources :customer_venders, only: :index

  namespace :api, defaults: {format: "json"} do
    devise_for :users, only: :session
    scope module: :v1 do
      resources :users, only: [:index]
      resources :log_books, only: [:index]
      resources :journal_entries, only: [:index]
      resources :item_lists, only: :index
      resources :chart_of_accounts, only: :index
    end
  end

  get "partners/:status" => "customer_venders#index", as: :partners
  post "partners/:status" => "customer_venders#create"
  get "partners/:status/new" => "customer_venders#new", as: :new_partner
  get "partners/:status/:id/edit" => "customer_venders#edit", as: :edit_partner
  get "partners/:status/:id" => "customer_venders#show", as: :partner
  patch "partners/:status/:id" => "customer_venders#update"
  delete "partners/:status/:id" => "customer_venders#destroy"

  get "partner/modal/:status/:id" => "confirm_modals#modal_customer_vender", as: :modal_customer_vender

  get "select_journal/:transaction_date/:cash_type_id/:journal_entry_id" => "journal_entries#select_journal"
  get "chart_of_account/:id" => "confirm_modals#modal_chart_of_account", as: :modal_chart_of_account
end

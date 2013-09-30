AddressBookApp::Application.routes.draw do
  get "static_pages/authorize"
  devise_for :users
  root :to => "home#index"
  resources :users
  resources :contacts

  namespace :api do
    resources :contacts
    resources :webhooks
    get '*path', :to => redirect("/api/%{path}")
  end
end

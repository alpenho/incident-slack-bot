require 'sidekiq/web'
Rails.application.routes.draw do
  resources :incidents do
    collection do
      get 'list'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'incidents#index'
  post '/rootly', :to => 'rootlies#rootly'
  mount Sidekiq::Web => '/sidekiq'
end

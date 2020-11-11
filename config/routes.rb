Rails.application.routes.draw do
  root to: 'home#top'
  resources :meal_tasks
  
  resources :users, :except => :index
  
  namespace :admin do
    get 'users/index'
    delete 'users/:id/destroy' => "users#destroy"
  end
  
  get '/calendar/index'
  get '/calendar/show'
  
  get "/meal_tags/:id/index" => "meal_tags#index"
  
  get '/login' => "sessions#new"
  post '/login' => "sessions#create"
  delete 'logout' => "sessions#destroy"

  get "/about" => "home#about"
  get "/policy" => "home#policy"
  get "/contact" => "home#contact"
  get "/faqs" => "home#faqs"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

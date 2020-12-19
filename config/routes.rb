Rails.application.routes.draw do

  root 'home#top'
  resources :meal_tasks, :except => :index
  resources :tasks, :except => :index
  resources :task_tags, :except => [:new, :edit]
  resources :meal_comments, :only => [:create, :destroy]
  resources :task_comments, :only => [:create, :destroy]
  resources :user_memos, :only => [:create, :update, :destroy]

  resources :users, :except => :index
  get "users/:id/other_tasks" => "users#other_tasks"
  get "users/:id/memos" => "users#memos"
  get "/users" => "users#new"

  namespace :admin do
    get 'users/index'
    delete 'users/:id/destroy' => "users#destroy"
    get 'users/histories_index'
  end

  get '/calendar/index'
  get '/calendar/show'
  get '/calendar/show/other_tasks' => "calendar#other_tasks"

  get "/meal_tags/:id" => "meal_tags#show"
  get "/meal_tags" => "task_tags#meal_tags"

  resources :meal_tasks do
    collection do
      match 'search' => 'users#search', via: [:get, :post], as: :search
    end
  end

  get '/login' => "sessions#new"
  post '/login' => "sessions#create"
  delete 'logout' => "sessions#destroy"

  get "/about" => "home#about"
  get "/policy" => "home#policy"
  get "/privacy_policy" => "home#privacy_policy"
  get "/faqs" => "home#faqs"
  post "/inquiry" => "home#send_inquiry"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

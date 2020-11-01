Rails.application.routes.draw do
  root to: 'home#top'
  resources :meal_tasks

  get "meal_tags/:id/index" => "meal_tags#index"

  get "about" => "home#about"
  get "policy" => "home#policy"
  get "contact" => "home#contact"
  get "faqs" => "home#faqs"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

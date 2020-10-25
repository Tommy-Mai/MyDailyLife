Rails.application.routes.draw do
  get '/' => "home#top"
  get "about" => "home#about"
  get "policy" => "home#policy"
  get "contact" => "home#contact"
  get "faqs" => "home#faqs"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

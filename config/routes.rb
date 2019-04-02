Rails.application.routes.draw do
  root to: "videos#index"
  get '/video/change', to: 'videos#change'
  resources :videos
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

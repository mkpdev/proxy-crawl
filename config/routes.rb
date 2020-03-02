Rails.application.routes.draw do
  root to: 'home#index'

  resources :web_crawl, only: [:index, :new] do
    collection do
      post :crawl
    end
  end
end

Rails.application.routes.draw do

  get "/token/:name", to: "screens#show"

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  devise_for :users
  resource :kiosk, only: :show

  root to: 'kiosk#show'

  get "/:code", to: "kiosk#show"

  mount ActionCable.server, at: '/cable'
end

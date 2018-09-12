Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :commuter_departures, only: [:index]

  get "/north-station", to: redirect("/commuter_departures?stop_id=place-north")
  get "/south-station", to: redirect("/commuter_departures?stop_id=place-sstat")
end

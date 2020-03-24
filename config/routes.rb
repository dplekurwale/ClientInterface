Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :user, only: [:create, :show] do
    get :login
    get :sign_up
    post :create_session
    get :logout
  end

  resource :home, only: [:show] do
  end

  root :to => "homes#show"
end
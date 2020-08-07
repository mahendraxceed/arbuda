Rails.application.routes.draw do

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  root 'home#index'


  resources :users do
    collection do
      post :search
    end
  end

  resources :customers do
    member do
      get :search_by_mobile
    end
    collection do
      post :search
    end
  end

  resources :complains, except: [:destroy] do
    member do
      get :status_transitions
      post :resend_sms
    end
    collection do
      post :search
    end
  end
end

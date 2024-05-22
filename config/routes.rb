Rails.application.routes.draw do
  get 'current_user', to:'current_user#index'
  patch 'current_user/update_password', to: 'current_user#update_password'

  devise_for :users, path:'', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :api do
    namespace :v1 do
      resources :posts do
        collection do
          get 'all_posts'
        end
      end
      resources :types do
      end
    end
  end
end

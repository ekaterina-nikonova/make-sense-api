Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'me', to: 'users#me'
      post 'signup', to: 'signup#create'
      post 'signin', to: 'signin#create'
      post 'refresh', to: 'refresh#create'
      delete 'signin', to: 'signin#destroy'

      resources :boards do
        get 'components' => :components
      end

      resources :uploads

      resources :components

      namespace :admin do
        resources :invitations, only: %i[create destroy]

        resources :users, only: %i[index destroy]

        namespace :users do
          resources :boards, only: %i[index]
          resources :components, only: %i[index]
        end
      end

      mount ActionCable.server => '/cable'
    end
  end
end

Rails.application.routes.draw do
  resources :users do
    get :destroy, on: :member, as: :destroy, path: 'destroy'
  end

  mount MountableFileServer::Server, at: '/uploads'
end

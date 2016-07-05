Rails.application.routes.draw do
  resources :users

  mount MountableFileServer::Server, at: '/uploads'
end

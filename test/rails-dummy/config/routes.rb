Rails.application.routes.draw do
  resources :users

  mount MountableFileServer::Backend => '/uploads'
end

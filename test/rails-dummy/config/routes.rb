Rails.application.routes.draw do
  resources :users

  mount MountableFileServer::Backend.new, at: '/uploads'
end

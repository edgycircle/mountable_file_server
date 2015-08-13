Rails.application.routes.draw do
  resources :users

  mount MountableFileServer::Endpoint, at: MountableFileServer.configuration.mounted_at
end

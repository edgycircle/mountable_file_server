Rails.application.routes.draw do
  resources :users

  mount MountableFileServer::Endpoint.new(Rails.configuration.mountable_file_server), at: Rails.configuration.mountable_file_server.mounted_at
end

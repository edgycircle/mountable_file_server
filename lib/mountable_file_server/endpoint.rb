require 'sinatra'

module MountableFileServer
  class Endpoint < Sinatra::Base
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
      super
    end

    post '/' do
      upload = MountableFileServer::Upload.new file: params[:file], type: params[:type]
      storage = MountableFileServer::Storage.new configuration
      storage.store_temporary upload: upload
    end
  end
end

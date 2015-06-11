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
    end
  end
end

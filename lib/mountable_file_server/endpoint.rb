require 'sinatra'

module MountableFileServer
  class Endpoint < Sinatra::Base
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
      super
    end

    post '/' do
      upload = Upload.new file: params[:file], type: params[:type]
      storage = Storage.new configuration
      storage.store_temporary(upload: upload).to_str
    end

    get '/*' do
      deliver_file unescape(request.path_info)
    end

    def deliver_file(filename)
      path_to_file = File.join(configuration.stored_at, 'public', filename)

      if File.file?(path_to_file)
        send_file path_to_file
      else
        not_found
      end
    end
  end
end

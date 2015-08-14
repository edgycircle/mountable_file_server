require 'sinatra'
require 'url_safe_base64'
require 'mini_magick'
require 'pathname'

module MountableFileServer
  class Endpoint < Sinatra::Base
    attr_reader :configuration

    def initialize(configuration = MountableFileServer.configuration)
      @configuration = configuration
      super
    end

    post '/' do
      pathname = Pathname(params[:file][:tempfile].path)
      type = params[:type]
      adapter = Adapter.new configuration

      adapter.store_temporary pathname, type, pathname.extname
    end

    get '/*' do
      deliver_file unescape(request.path_info)
    end

    def deliver_file(filename)
      path_to_file = File.join(configuration.stored_at, 'public', filename)

      if File.file?(path_to_file)
        send_file path_to_file
      else
        if filename.count('.') == 2
          parts = filename.split('.')
          base_filename = "#{parts[0]}.#{parts[2]}"
          path_to_base_file = File.join(configuration.stored_at, 'public', base_filename)

          if File.file?(path_to_base_file)
            resize_command = UrlSafeBase64.decode64 parts[1]
            image = MiniMagick::Image.open path_to_base_file
            image.resize resize_command.to_s
            image.write path_to_file
            send_file path_to_file
          else
            not_found
          end
        else
          not_found
        end

        not_found
      end
    end
  end
end

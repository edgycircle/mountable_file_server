require "sinatra"

module MountableFileServer
  class Backend < Sinatra::Base
    def initialize
      super

      FileUtils.mkdir_p File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, 'public')
      FileUtils.mkdir_p File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, 'tmp')
    end

    post '/' do
      process_file_upload(params[:file])
    end

    get '/*' do
      deliver_upload unescape(request.path_info)
    end

    def process_file_upload(file_parameters)
      extension = File.extname file_parameters[:filename]
      visibility_prefix = 'public'
      random_filename = generate_filename(visibility_prefix, extension)

      File.open(File.join(temporary_directoryname, random_filename), 'wb') do |file|
        file.write file_parameters[:tempfile].read
      end

      random_filename
    end

    # process_file_request
    # process_file_upload
    def deliver_upload(name)
      path_to_upload = File.expand_path("#{File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, 'public')}#{name}")

      if File.file?(path_to_upload)
        send_file path_to_upload
      else
        pass
      end
    end

    private
    def generate_filename(visibility_prefix, extension)
      loop do
        random_token = SecureRandom.hex
        filename = "#{visibility_prefix}-#{random_token}#{extension}"
        break filename unless File.exists?(File.join(final_directoryname(visibility_prefix), filename)) ||
                                  File.exists?(File.join(temporary_directoryname, filename))
      end
    end

    def final_directoryname(visibility_prefix)
      File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, visibility_prefix)
    end

    def temporary_directoryname
      File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, 'tmp')
    end
  end
end

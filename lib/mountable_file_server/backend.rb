require "sinatra"

module MountableFileServer
  class Backend < Sinatra::Base
    # set :static, true
    # set :public_folder, Proc.new { File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, 'public') }

    def initialize
      super

      FileUtils.mkdir_p File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, 'public')
      FileUtils.mkdir_p File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, 'tmp')
    end

    post '/public-upload' do
      extension = File.extname params[:file][:filename]
      visibility_prefix = 'public'
      random_filename = generate_filename(visibility_prefix, extension)

      File.open(File.join(temporary_directoryname, random_filename), 'wb') do |file|
        file.write params[:file][:tempfile].read
      end

      random_filename
    end

    get '/*' do
      params[:splat]

      path = File.expand_path("#{File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, 'public')}#{unescape(request.path_info)}")

      if File.file?(path)
        send_file path
      else
        File.basename path
      end
    end

    # not_found do
    #   "LOL"
    # end

    # def static!(options = {})
    #   return if (public_dir = settings.public_folder).nil?
    #   path = File.expand_path("#{public_dir}#{unescape(request.path_info)}" )
    #   return unless File.file?(path)

    #   env['sinatra.static_file'] = path
    #   cache_control(*settings.static_cache_control) if settings.static_cache_control?
    #   send_file path, options.merge(:disposition => nil)
    # end



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

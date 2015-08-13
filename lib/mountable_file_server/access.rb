require 'url_safe_base64'

module MountableFileServer
  class Access
    NotAccessibleViaURL = Class.new(ArgumentError)

    attr_reader :configuration

    def initialize(configuration = MountableFileServer.configuration)
      @configuration = configuration
    end

    def temporary_path_for(identifier:)
      File.join configuration.stored_at, 'tmp', identifier
    end

    def path_for(identifier:)
      identifier = Identifier.new identifier
      File.join configuration.stored_at, identifier.type, identifier.filename
    end

    def url_for(identifier:, resize: nil)
      identifier = Identifier.new identifier

      raise NotAccessibleViaURL unless identifier.public?

      if resize
        resize_part = UrlSafeBase64.encode64 resize
        File.join configuration.mounted_at, identifier.filename.gsub('.', ".#{resize_part}.")
      else
        File.join configuration.mounted_at, identifier.filename
      end
    end

    def file_for(identifier:)
      paths = [
                path_for(identifier: identifier),
                temporary_path_for(identifier: identifier)
              ]

      File.new paths.find { |path| File.file? path }
    end
  end
end

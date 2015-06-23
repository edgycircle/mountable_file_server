module MountableFileServer
  class Access
    NotAccessibleViaURL = Class.new(ArgumentError)

    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def temporary_path_for(identifier:)
      File.join configuration.stored_at, 'tmp', identifier
    end

    def path_for(identifier:)
      identifier = Identifier.new identifier
      File.join configuration.stored_at, identifier.type, identifier.filename
    end

    def url_for(identifier:)
      identifier = Identifier.new identifier

      raise NotAccessibleViaURL unless identifier.public?

      File.join configuration.mounted_at, identifier.filename
    end
  end
end

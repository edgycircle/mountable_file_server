module MountableFileServer
  class Adapter
    attr_reader :configuration

    def initialize(configuration = MountableFileServer.configuration)
      @configuration = configuration
    end

    def store_temporary(io, type, extension)
      id = random_identifier type, extension
      Storage.new(Persistor, configuration).store_temporary io, id
      id
    end

    def store_permanent(io, type, extension)
      id = random_identifier type, extension
      Storage.new(Persistor, configuration).store_permanent io, id
      id
    end

    def move_to_permanent_storage(identifier)
      Storage.new(Persistor, configuration).move_to_permanent_storage identifier
    end

    def remove_from_permanent_storage(identifier)
      Storage.new(Persistor, configuration).remove_from_permanent_storage identifier
    end

    def url_for(id)
      id = Identifier.new id
      FileAccessor.new(id, configuration).url
    end

    def pathname_for(id)
      id = Identifier.new id
      FileAccessor.new(id, configuration).pathname
    end

    private
    def random_identifier(type, extension)
      loop do
        id = Identifier.generate_for extension, type
        break id unless FileAccessor.new(id, configuration).exist?
      end
    end
  end
end

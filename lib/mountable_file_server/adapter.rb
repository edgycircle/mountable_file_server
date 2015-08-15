module MountableFileServer
  class Adapter
    attr_reader :configuration

    def initialize(configuration = MountableFileServer.configuration)
      @configuration = configuration
    end

    def store_temporary(input, type, extension)
      id = generate_random_id type, extension
      Storage.new(configuration).store_temporary id, input
      id
    end

    def store_permanent(input, type, extension)
      id = generate_random_id type, extension
      Storage.new(configuration).store_permanent id, input
      id
    end

    def move_to_permanent_storage(id)
      id = Identifier.new id
      Storage.new(configuration).move_to_permanent_storage id
    end

    def remove_from_permanent_storage(id)
      id = Identifier.new id
      Storage.new(configuration).remove_from_permanent_storage id
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
    def generate_random_id(type, extension)
      loop do
        id = Identifier.generate_for extension, type
        break id unless FileAccessor.new(id, configuration).exist?
      end
    end
  end
end

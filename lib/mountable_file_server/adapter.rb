module MountableFileServer
  class Adapter
    attr_reader :configuration

    def initialize(configuration = MountableFileServer.configuration)
      @configuration = configuration
    end

    def store_temporary(input, type, extension)
      uid = generate_random_uid type, extension
      Storage.new(configuration).store_temporary uid, input
      uid
    end

    def store_permanent(input, type, extension)
      uid = generate_random_uid type, extension
      Storage.new(configuration).store_permanent uid, input
      uid
    end

    def move_to_permanent_storage(uid)
      uid = UniqueIdentifier.new uid
      Storage.new(configuration).move_to_permanent_storage uid
    end

    def remove_from_permanent_storage(uid)
      uid = UniqueIdentifier.new uid
      Storage.new(configuration).remove_from_permanent_storage uid
    end

    def url_for(uid)
      uid = UniqueIdentifier.new uid
      FileAccessor.new(uid, configuration).url
    end

    def pathname_for(uid)
      uid = UniqueIdentifier.new uid
      FileAccessor.new(uid, configuration).pathname
    end

    private
    def generate_random_uid(type, extension)
      loop do
        uid = UniqueIdentifier.generate_for type, extension
        break uid unless FileAccessor.new(uid, configuration).exist?
      end
    end
  end
end

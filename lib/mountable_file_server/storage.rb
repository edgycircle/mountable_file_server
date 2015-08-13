module MountableFileServer
  class Storage
    attr_reader :persistor_class, :configuration

    def initialize(persistor_class = Persistor, configuration = MountableFileServer.configuration)
      @configuration = configuration
      @persistor_class = persistor_class
    end

    def store_temporary(io, identifier)
      pathname = FileAccessor.new(identifier, configuration).temporary_pathname
      persistor = persistor_class.new pathname
      persistor.save io
    end

    def store_permanent(io, identifier)
      pathname = FileAccessor.new(identifier, configuration).permanent_pathname
      persistor = persistor_class.new pathname
      persistor.save io
    end

    def move_to_permanent_storage(identifier)
      accessor = FileAccessor.new(identifier, configuration)
      temporary_pathname = accessor.temporary_pathname
      permanent_pathname = accessor.permanent_pathname
      persistor = persistor_class.new temporary_pathname
      persistor.rename permanent_pathname
    end

    def remove_from_permanent_storage(identifier)
      pathname = FileAccessor.new(identifier, configuration).permanent_pathname
      persistor = persistor_class.new pathname
      persistor.delete
    end
  end
end

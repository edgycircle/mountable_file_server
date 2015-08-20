module MountableFileServer
  class Storage
    attr_reader :configuration

    def initialize(configuration = MountableFileServer.configuration)
      @configuration = configuration
    end

    def store_temporary(uid, input)
      destination = FileAccessor.new(uid, configuration).temporary_pathname
      destination.dirname.mkpath
      IO.copy_stream input, destination
    end

    def store_permanent(uid, input)
      destination = FileAccessor.new(uid, configuration).permanent_pathname
      destination.dirname.mkpath
      IO.copy_stream input, destination
    end

    def move_to_permanent_storage(uid)
      source = FileAccessor.new(uid, configuration).temporary_pathname
      destination = FileAccessor.new(uid, configuration).permanent_pathname
      destination.dirname.mkpath

      source.rename destination
    end

    def remove_from_permanent_storage(uid)
      source = FileAccessor.new(uid, configuration).permanent_pathname
      source.delete
    end
  end
end

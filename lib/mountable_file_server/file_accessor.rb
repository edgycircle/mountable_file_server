require 'pathname'

module MountableFileServer
  NoFileForIdentifier = Class.new(ArgumentError)
  NotAccessibleViaURL = Class.new(ArgumentError)

  class FileAccessor
    attr_reader :id, :configuration

    def initialize(id, configuration = MountableFileServer.configuration)
      @id = id
      @configuration = configuration
    end

    def temporary_pathname
      Pathname(configuration.stored_at) + 'tmp' + id
    end

    def permanent_pathname
      Pathname(configuration.stored_at) + id.type +  id
    end

    def pathname
      pathnames.find(-> { raise NoFileForIdentifier }) { |p| p.file? }
    end

    def exist?
      pathnames.any? { |p| p.file? }
    end

    def url
      raise NotAccessibleViaURL unless id.public?

      URI.new (Pathname(configuration.mounted_at) + id).to_s
    end

    private
    def pathnames
      [permanent_pathname, temporary_pathname]
    end
  end
end

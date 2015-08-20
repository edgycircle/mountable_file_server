require 'pathname'

module MountableFileServer
  MissingFile = Class.new(ArgumentError)
  NotAccessibleViaURL = Class.new(ArgumentError)

  class FileAccessor
    attr_reader :uid, :configuration

    def initialize(uid, configuration = MountableFileServer.configuration)
      @uid = uid
      @configuration = configuration
    end

    def temporary_pathname
      Pathname(configuration.stored_at) + 'tmp' + uid
    end

    def permanent_pathname
      Pathname(configuration.stored_at) + uid.type +  uid
    end

    def pathname
      pathnames.find(-> { raise MissingFile }) { |p| p.file? }
    end

    def exist?
      pathnames.any? { |p| p.file? }
    end

    def url
      raise NotAccessibleViaURL unless uid.public?

      URI.new (Pathname(configuration.mounted_at) + uid).to_s
    end

    private
    def pathnames
      [permanent_pathname, temporary_pathname]
    end
  end
end

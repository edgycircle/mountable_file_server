require 'mountable_file_server/uri'
require 'pathname'

module MountableFileServer
  MissingFile = Class.new(ArgumentError)
  NotAccessibleViaURL = Class.new(ArgumentError)

  class FileAccessor
    attr_reader :uid, :configuration

    def initialize(uid, configuration = MountableFileServer.config)
      @uid = uid
      @configuration = configuration
    end

    def temporary_pathname
      Pathname(configuration.storage_path) + 'tmp' + uid
    end

    def permanent_pathname
      Pathname(configuration.storage_path) + uid.type + uid
    end

    def pathname
      pathnames.find(-> { raise MissingFile }) { |p| p.file? }
    end

    def exist?
      pathnames.any? { |p| p.file? }
    end

    def url
      raise NotAccessibleViaURL unless uid.public?

      URI.new (Pathname(configuration.base_url) + uid).to_s
    end

    private
    def pathnames
      [permanent_pathname, temporary_pathname]
    end
  end
end

module MountableFileServer
  class Configuration
    attr_accessor :mounted_at, :stored_at

    def initialize(mounted_at = '', stored_at = '')
      @mounted_at = mounted_at
      @stored_at = stored_at
    end
  end
end

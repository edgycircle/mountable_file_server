require "gem_config"

require "mountable_file_server/version"

module MountableFileServer
  include GemConfig::Base

  with_configuration do
    has :mounted_at, classes: String, default: '/uploads'
    has :stored_at, classes: String, default: 'uploads'
    has :input_class, classes: String, default: 'mountable-file-server-input'
    has :root, default: ''
  end

  require "mountable_file_server/backend"
  require "mountable_file_server/engine"
  require "mountable_file_server/access_helper"
  require "mountable_file_server/storage_helper"

  @@testing = false

  class << self
    def me
      puts __FILE__
    end

    def public_upload_url
      "#{self.configuration.mounted_at}/public-upload"
    end

    def remove_files!
      raise SecurityError.new 'remove_files! works only under testing mode' unless @@testing

      FileUtils.rm_rf MountableFileServer.configuration.stored_at
    end

    def testing!
      @@testing = true
    end

    def default!
      @@testing = false
    end
  end
end

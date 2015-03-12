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

  class << self
    def public_upload_url
      "#{self.configuration.mounted_at}/public-upload"
    end
  end
end

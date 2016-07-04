require "dry-configurable"

require "mountable_file_server/version"

module MountableFileServer
  extend Dry::Configurable

  setting :base_url
  setting :storage_path
end

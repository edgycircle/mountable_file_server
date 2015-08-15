require "mountable_file_server/version"

module MountableFileServer
  require "mountable_file_server/configuration"
  require "mountable_file_server/file_accessor"
  require "mountable_file_server/identifier"
  require "mountable_file_server/storage"

  require "mountable_file_server/endpoint"
  require "mountable_file_server/adapter"
  require "mountable_file_server/access"

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require "mountable_file_server/version"

module MountableFileServer
  require "mountable_file_server/configuration"

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

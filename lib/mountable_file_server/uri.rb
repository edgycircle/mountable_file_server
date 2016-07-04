require 'uri'
require 'pathname'

module MountableFileServer
  class URI < String
    def initialize(string)
      super.freeze
    end

    def uid
      UniqueIdentifier.new filename
    end

    def filename
      Pathname(::URI.parse(self).path).basename.to_s
    end
  end
end

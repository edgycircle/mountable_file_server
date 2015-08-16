require 'uri'
require 'pathname'
require 'url_safe_base64'

module MountableFileServer
  class URI < String
    def initialize(string)
      super.freeze
    end

    def id
      Identifier.new filename
    end

    def encoded_processing_instructions
      /\.(\w+)\./.match(filename).captures.first
    end

    def decoded_processing_instructions
      UrlSafeBase64.decode64 encoded_processing_instructions
    end

    def filename
      Pathname(::URI.parse(self).path).basename.to_s
    end

    def resize(instructions)
      encoded_instructions = UrlSafeBase64.encode64 instructions

      URI.new self.gsub('.', ".#{encoded_instructions}.")
    end
  end
end

require 'securerandom'

module MountableFileServer
  UnknownType = Class.new(ArgumentError)

  class Identifier < String
    attr_reader :type, :filename

    def initialize(string)
      @type, @filename = /(\w+)-(.+)$/.match(string).captures

      raise UnknownType.new(type) unless known_type?

      super.freeze
    end

    def self.generate_for(extension, type)
      new "#{type}-#{SecureRandom.hex}#{extension}"
    end

    def public?
      type == 'public'
    end

    private
    def known_type?
      ['public', 'private'].include?(type)
    end
  end
end

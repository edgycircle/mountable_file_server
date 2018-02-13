require 'securerandom'

module MountableFileServer
  UnknownType = Class.new(ArgumentError)
  MalformedIdentifier = Class.new(ArgumentError)

  class UniqueIdentifier < String
    attr_reader :type, :filename

    def initialize(string)
      raise MalformedIdentifier.new unless /(\w+)-(.+)$/.match(string)

      @type, @filename = /(\w+)-(.+)$/.match(string).captures

      raise UnknownType.new(type) unless known_type?

      super.freeze
    end

    def self.generate_for(type, extension)
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

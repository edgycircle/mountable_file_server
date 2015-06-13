require 'securerandom'

module MountableFileServer
  class Identifier
    attr_reader :type, :filename

    def self.generate_for(filename:, type:)
      extension = File.extname filename

      new "#{type}-#{SecureRandom.hex}#{extension}"
    end

    def initialize(identifier)
      @type = /(\w+)-\w+/.match(identifier)[1]
      @filename = /\w+-(.+)$/.match(identifier)[1]

      raise ArgumentError.new("Unkown type `#{type}`") unless valid_type?
    end

    def to_str
      "#{type}-#{filename}"
    end

    def ==(other)
      to_str == other.to_str
    end

  private
    def valid_type?
      ['public', 'private'].include?(type)
    end
  end
end

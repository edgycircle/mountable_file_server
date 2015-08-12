require 'securerandom'

module MountableFileServer
  class Identifier < String
    attr_reader :type, :filename

    def initialize(string)
      @type, @filename = /(\w+)-(.+)$/.match(string).captures

      raise ArgumentError.new("Unkown type `#{type}`") unless known_type?

      super.freeze
    end

    def self.generate_for(filename:, type:)
      new "#{type}-#{SecureRandom.hex}#{File.extname(filename)}"
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

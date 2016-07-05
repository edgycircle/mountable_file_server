require 'dimensions'

module MountableFileServer
  class Metadata
    attr_reader :size, :content_type, :height, :width

    def initialize(size:, content_type:, width: nil, height: nil)
      @size = size
      @content_type = content_type
      @width = width
      @height = height
    end

    def to_h
      hash = {
        size: size,
        content_type: content_type
      }

      if width && height
        hash = hash.merge({
          height: height,
          width: width
        })
      end

      hash
    end

    def self.for_path(path)
      parameters = {}

      parameters[:content_type] = `file --brief --mime-type #{path}`.strip
      parameters[:size] = File.size(path)

      if ['image/png', 'image/jpeg', 'image/gif'].include?(parameters[:content_type])
        dimensions = Dimensions.dimensions(path)
        parameters[:width] = dimensions[0]
        parameters[:height] = dimensions[1]
      end

      new(parameters)
    end
  end
end

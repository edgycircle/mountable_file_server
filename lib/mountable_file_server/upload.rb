module MountableFileServer
  class Upload
    attr_reader :file, :type

    def initialize(file:, type:)
      @file = file
      @type = type
    end

    def file_extension
      File.extname file[:filename]
    end

    def read
      @cached_read ||= file[:tempfile].read
    end
  end
end

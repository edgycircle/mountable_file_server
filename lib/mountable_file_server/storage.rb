module MountableFileServer
  class Storage
    attr_reader :access

    def initialize(configuration)
      @access = Access.new configuration
    end

    def store_temporary(upload:)
      filename = upload.filename
      type = upload.type
      identifier = random_identifier filename: filename, type: type
      path = access.temporary_path_for identifier: identifier

      File.open(path, 'wb') do |file|
        file.write upload.read
      end

      identifier
    end

    def move_to_permanent_storage(identifier:)
      identifier = Identifier.new identifier
      from = access.temporary_path_for identifier: identifier
      to = access.path_for identifier: identifier

      FileUtils.move from, to
    end

  private
    def random_identifier(filename:, type:)
      loop do
        identifier = Identifier.generate_for filename: filename, type: type
        path = access.temporary_path_for identifier: identifier

        break identifier unless File.exists?(path)
      end
    end
  end
end

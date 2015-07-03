module MountableFileServer
  class Storage
    attr_reader :access

    def initialize(configuration)
      @access = Access.new configuration
    end

    def store_temporary(path:, type:, filename:)
      file_to_be_stored = File.new path
      identifier = random_identifier filename: filename, type: type
      path = access.temporary_path_for identifier: identifier

      File.open(path, 'wb') do |file|
        file.write file_to_be_stored.read
      end

      identifier
    end

    def store_permanently(path:, type:, filename:)
      identifier = store_temporary path: path, type: type, filename: filename
      move_to_permanent_storage identifier: identifier
      identifier
    end

    def move_to_permanent_storage(identifier:)
      identifier = Identifier.new identifier
      from = access.temporary_path_for identifier: identifier
      to = access.path_for identifier: identifier

      FileUtils.move from, to
    end

    def remove_from_permanent_storage(identifier:)
      identifier = Identifier.new identifier
      path = access.path_for identifier: identifier

      FileUtils.rm path
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

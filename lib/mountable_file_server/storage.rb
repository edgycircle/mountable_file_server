module MountableFileServer
  class Storage
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def store_temporary(upload:)
      filename = upload.filename
      type = upload.type
      identifier, path = random_identifier filename: filename, type: type

      File.open(path, 'wb') do |file|
        file.write upload.read
      end

      identifier
    end

    def move_to_permanent_storage(identifier:)
      identifier = Identifier.new identifier
      from = File.join(configuration.stored_at, 'tmp', identifier)
      to = File.join(configuration.stored_at, identifier.type, identifier.filename)

      FileUtils.move from, to
    end

    def url_for(identifier:)
      identifier = Identifier.new identifier

      raise ArgumentError.new('Private identifiers are not accessible via HTTP and therefore do not have an associated URL.') if identifier.type == 'private'

      File.join configuration.mounted_at, identifier.filename
    end

    def path_for(identifier:)
      identifier = Identifier.new identifier
      File.join configuration.stored_at, identifier.type, identifier.filename
    end

  private
    def random_identifier(filename:, type:)
      identifier = nil
      path = nil

      loop do
        identifier = Identifier.generate_for filename: filename, type: type
        path = File.join(configuration.stored_at, 'tmp', identifier)

        break unless File.exists?(path)
      end

      return identifier, path
    end
  end
end

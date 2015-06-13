module MountableFileServer
  class Storage
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def store_temporary(upload:)
      file_extension = upload.file_extension
      file_path = nil
      identifier = nil

      loop do
        identifier = "#{upload.type}-#{SecureRandom.hex}#{file_extension}"
        file_path = File.join(configuration.stored_at, 'tmp', identifier)

        break unless File.exists?(file_path)
      end

      File.open(file_path, 'wb') do |file|
        file.write upload.read
      end

      identifier
    end

    def move_to_permanent_storage(identifier:)
      type = identifier.match(/(\w+)-\w+/)[1]
      filename = identifier.gsub("#{type}-", '')
      from = File.join(configuration.stored_at, 'tmp', identifier)
      to = File.join(configuration.stored_at, type, filename)

      FileUtils.move from, to
    end

    def url_for(identifier:)
      type = identifier.match(/(\w+)-\w+/)[1]

      raise ArgumentError.new('Private identifiers are not accessible via HTTP and therefore do not have an associated URL.') if type == 'private'

      filename = identifier.gsub("#{type}-", '')

      File.join configuration.mounted_at, filename
    end

    def path_for(identifier:)
      type = identifier.match(/(\w+)-\w+/)[1]
      filename = identifier.gsub("#{type}-", '')

      File.join configuration.stored_at, type, filename
    end
  end
end

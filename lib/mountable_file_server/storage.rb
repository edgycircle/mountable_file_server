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
  end
end

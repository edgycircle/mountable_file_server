require 'mountable_file_server'

module MountableFileServer
  class Testing
    class << self
      attr_accessor :mode, :fixture_pathname

      def disable!
        self.mode = :disabled
      end

      def enable!
        self.mode = :normal
      end

      def fake!
        self.mode = :fake
      end

      def enabled?
        self.mode != :disabled
      end

      def disabled?
        self.mode == :disabled
      end

      def normal?
        self.mode == :normal
      end

      def fake?
        self.mode == :fake
      end

      def remove_uploads!
        FileUtils.rm_rf MountableFileServer.configuration.stored_at
      end
    end
  end

  class Backend
    alias_method :original_deliver_upload, :deliver_upload

    def deliver_upload(name)
      path_to_upload = File.expand_path("#{MountableFileServer::Testing.fixture_pathname}#{name}")

      if File.file?(path_to_upload)
        send_file path_to_upload
      else
        original_deliver_upload name
      end
    end
  end
end

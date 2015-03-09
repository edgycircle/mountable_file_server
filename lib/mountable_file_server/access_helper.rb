module MountableFileServer
  module AccessHelper
    def path_for_upload(filename)
      File.join(MountableFileServer.configuration.mounted_at, filename)
    end
  end
end

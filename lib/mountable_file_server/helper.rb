module MountableFileServer
  module Helper
    def move_upload_to_storage(filename)
      from = File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, 'tmp', filename)
      to = File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, 'public', filename)
      FileUtils.move from, to
    end

    def path_for_upload(filename)
      File.join(MountableFileServer.configuration.mounted_at, filename)
    end
  end
end

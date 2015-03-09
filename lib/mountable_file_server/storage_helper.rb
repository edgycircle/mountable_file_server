module MountableFileServer
  module StorageHelper
    def move_upload_to_storage(filename)
      from = File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, 'tmp', filename)
      to = File.join(MountableFileServer.configuration.root, MountableFileServer.configuration.stored_at, 'public', filename)
      FileUtils.move from, to
    end
  end
end

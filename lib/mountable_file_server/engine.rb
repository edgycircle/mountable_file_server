require "mountable_file_server/ajax_upload_helper"
require "mountable_file_server/access_helper"
require "mountable_file_server/storage_helper"

module MountableFileServer
  class Engine < ::Rails::Engine
    initializer "mountable_file_server.setup" do |app|
      ActionView::Base.send(:include, MountableFileServer::AjaxUploadHelper)
      ActionView::Helpers::FormBuilder.send(:include, AjaxUploadHelper::FormBuilder)
      ActionController::Base.send(:include, MountableFileServer::StorageHelper)
      ActionView::Base.send(:include, MountableFileServer::AccessHelper)
      MountableFileServer.configuration.root = app.root
    end
  end
end

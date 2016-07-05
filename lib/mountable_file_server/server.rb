require 'sinatra/base'
require 'pathname'

require 'mountable_file_server/adapter'
require 'mountable_file_server/metadata'

module MountableFileServer
  class Server < Sinatra::Base
    post '/' do
      adapter = Adapter.new
      pathname = Pathname(params[:file][:tempfile].path)
      type = params[:type]
      fid = adapter.store_temporary(pathname, type, pathname.extname)
      url = adapter.url_for(fid)
      metadata = Metadata.for_path(pathname)

      content_type :json
      status 201

      {
        fid: fid,
        url: url,
        metadata: metadata.to_h
      }.to_json
    end

    get '/:fid' do |fid|
      adapter = Adapter.new
      pathname = adapter.pathname_for(fid)
      send_file pathname
    end

    post '/:fid/store-permanent' do |fid|
      adapter = Adapter.new
      adapter.move_to_permanent_storage(fid)

      content_type :json
      status 200
    end

    delete '/:fid' do |fid|
      adapter = Adapter.new
      adapter.remove_from_storage(fid)

      content_type :json
      status 200
    end
  end
end

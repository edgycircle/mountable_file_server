require 'sinatra/base'
require 'pathname'

require 'mountable_file_server/adapter'

module MountableFileServer
  class Server < Sinatra::Base
    post '/' do
      adapter = Adapter.new
      pathname = Pathname(params[:file][:tempfile].path)
      type = params[:type]
      fid = adapter.store_temporary(pathname, type, pathname.extname)

      content_type :json
      status 201

      { fid: fid }.to_json
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

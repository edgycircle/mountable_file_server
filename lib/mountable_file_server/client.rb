require 'net/http'
require 'uri'
require 'stringio'

module MountableFileServer
  class Client
    def move_to_permanent_storage(fid)
      if MountableFileServer.config.base_url.start_with?('http')
      uri = ::URI.parse(MountableFileServer.config.base_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.set_debug_output($stdout)
      request = Net::HTTP::Post.new(uri.request_uri + fid + '/store-permanent')

      http.request(request)
      else
      MountableFileServer::Server.new.call({
        "rack.input" => StringIO.new(""),
        "REQUEST_METHOD"=> "POST",
        "PATH_INFO"=> "/#{fid}/store-permanent",
      })
      end
    end

    def remove_from_storage(fid)
      uri = ::URI.parse(MountableFileServer.config.base_url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Delete.new(uri.request_uri + fid)

      http.request(request)
    end

    def url_for(fid)
      MountableFileServer.config.base_url + fid
    end
  end
end

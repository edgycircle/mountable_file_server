require 'net/http'
require 'uri'

module MountableFileServer
  class Client
    def move_to_permanent_storage(fid)
      uri = ::URI.parse(MountableFileServer.config.base_url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri + fid)

      http.request(request)
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

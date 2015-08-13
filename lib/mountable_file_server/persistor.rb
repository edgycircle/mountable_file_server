require 'pathname'

module MountableFileServer
  class Persistor
    def initialize(destination)
      @destination = destination
    end

    def save(source)
      Pathname.new(@destination).dirname.mkpath
      IO.copy_stream source, @destination
    end
  end
end

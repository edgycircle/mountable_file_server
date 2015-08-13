require 'pathname'

module MountableFileServer
  class Persistor
    attr_reader :pathname

    def initialize(pathname)
      @pathname = Pathname(pathname)
    end

    def save(source)
      pathname.dirname.mkpath
      IO.copy_stream source, pathname
    end

    def delete
      pathname.delete
    end

    def rename(new_pathname)
      persistor = Persistor.new new_pathname
      persistor.save pathname
      delete
    end
  end
end

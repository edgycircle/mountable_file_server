module PathHelper
  def fixture_path(filename)
    File.expand_path(File.join('../fixtures', filename), File.dirname(__FILE__))
  end
end

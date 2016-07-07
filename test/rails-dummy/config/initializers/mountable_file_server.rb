MountableFileServer.configure do |config|
  config.base_url = '/uploads/'

  if Rails.env.test?
    config.storage_path = File.join(Rails.root, 'tmp', 'test-uploads')
  else
    config.storage_path = File.join(Rails.root, 'uploads')
  end
end

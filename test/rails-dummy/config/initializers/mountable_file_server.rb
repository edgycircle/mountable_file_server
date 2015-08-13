MountableFileServer.configure do |configuration|
  configuration.mounted_at = '/uploads'

  if Rails.env.test?
    configuration.stored_at = File.join(Rails.root, 'tmp', 'test-uploads')
  else
    configuration.stored_at = File.join(Rails.root, 'uploads')
  end
end

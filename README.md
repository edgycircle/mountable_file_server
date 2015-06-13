The fundamental idea is that your application only deals with identifiers of uploaded files in string form. No need to handle files directly. It should not complicate testing. It should allow files that are publicly accessible and private files that are not. Uploads happen via Ajax without additional work on the application developers side. It allows easy customization and adaption of the file upload process on the frontend to give a good user experience.

While it is possible to use in an Ruby on Rails application the gem itself does not depend on it and does not assume you use it.

## Concept
You mount a tiny Sinatra application, the `MountableFileServer::Endpoint`, at an URL path of your choosing. The endpoint accepts AJAX file uploads and can also deliver requested files that are already permanently stored. (Later on we take a closer look in which scenarios it makes sense to deliver file requests via the endpoint instead of your webserver.)

For every uploaded file the endpoint responds with an unique identifier, a simple string. This identifier allows you to identify an uploaded file later on. Therefore it is the only thing your application needs to know and persist. The JavaScript provided by the gem handles the AJAX file upload and writes the identifier to a hidden input field with the same `name` attribute as the original file input field. When the form is submitted your application only deals with a simple string value from a hidden input field instead of an actual file upload.

At first a newly uploaded file is only stored temporarly, when the user submits the form and your application deemed it valid and persists the data it is the applications responsibility to move the uploaded file to the permanent storage using the `MountableFileServer::Storage` class. This is necessary to prevent accumulating file garbage due to abandoned forms where an upload already happened.

## Moving Parts
`MountableFileServer::Endpoint` is a Sinatra application that can be mounted anywhere you want. It accepts uploads and responds with requested files if necessary. `MountableFileServer::Storage` is responsible for working with the actual files. Both take a `MountableFileServer::Configuration` which is used to define key settings specific to your usage scenario.

## Configuration
~~~ruby
configuration = MountableFileServer::Configuration.new stored_at: '~/uploads', mounted_at: '/uploads'
~~~

~~~ruby
storage = MountableFileServer::Storage.new config
upload = MountableFileServer::Upload.new file: file_parameters[:tempfile].read, type: 'public'

identifier = storage.store_temporary upload: upload
storage.move_to_permanent_storage identifier: identifier

storage.path_for identifier: identifier
storage.url_for identifier: identifier
~~~

~~~html
<div class="js-mountable-file-server-input">
  <input type="file" name="avatar" data-endpoint="/uploads" data-type="public">
  <input type="hidden" name="avatar">
</div>
~~~

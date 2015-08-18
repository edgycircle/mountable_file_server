MountableFileServer was born out of my frustations with existing Ruby based file upload solutions. It is certainly not comparable with existing feature-rich plug-and-play solutions that are tied to Ruby on Rails.

The fundamental idea is that your application should not be tied to files or handling the upload process. Instead this is handled by a dedicated server which can be run as independet process or be mounted inside your application. It accepts file uploads and returns an unique identifier for the file. This unique identifier is basically a string and the only thing your application has to remember in order to work with uploaded files.

* JavaScript function to upload files via AJAX.
* JavaScript events regarding the uploads various states.
* Uploaded files are stored on disk.
* Filenames are unique and random sequences of charaters.
* Uploaded files are stored temporary until they are explicitly moved to permanent storage by the application.
* Uploaded files can be of public or private nature.
* Private files can't be accessed via an URL.

Things it does not do:

* Image processing. Processing images has nothing to do with uploading files. [MountableImageProcessor]() is recommended for adding on the fly image processing to your application.

## Install & Setup
Add the MountableFileServer gem to your Gemfile and `bundle install`. Make sure you include `vendor/assets/javascripts/mountable_file_server.js` in your frontend code.

~~~ruby
gem 'mountable_file_server', '~> 0.0.2'
~~~

If your application is built upon Ruby on Rails you can add a require statement in your Gemfile. This includes an Ruby on Rails engine which allows you to require the JavaScript.

~~~ruby
gem 'mountable_file_server', '~> 0.0.2', require: 'mountable_file_server/rails'
~~~

~~~javascript
//= require mountable_file_server
~~~

Once installed it is time to run the server so file uploads can be made. The server is called `MountableFileServer::Endpoint` and is a minimal Sinatra application which can be run as usual. You can also mount an endpoint inside your existing application. With Ruby on Rails this would look like this.

~~~ruby
Rails.application.routes.draw do
  mount MountableFileServer::Endpoint, at: MountableFileServer.configuration.mounted_at
end
~~~

## Configuration
As seen in the previous section there is a global configration at `MountableFileServer.configuration` available. This is an instance of `MountableFileServer::Configration`. The global configuration is a default argument for all classes that require access to the configuration. In situations where you have multiple endpoints with different settings you can pass in you own configuration objects instead.

The global configuration can be configured through a block.

~~~ruby
MountableFileServer.configure do |configuration|
  configuration.mounted_at = '/uploads'
  configuration.stored_at = '/path/to/desired/uploads/directory'
end
~~~

In order to build correct URLs to public files the `mounted_at` attribute should be set to the path where the endpoint is mounted.

The `stored_at` attribute tells the MountableFileServer where to store uploaded files. It will automatically create this and all needed subdirectories. This directory should not be within the root of your webserver. Otherwise private files are accessible to the internet.

## Usage








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
<input type="file" name="avatar" data-endpoint="/uploads" data-type="public">
~~~



Wieso ist MFS besser?

Losgekoppelt von der Anwendung / Active Record
Beispiel Schaltwerk beim Fahrrad im Bezug auf Versionen
Komplexe Lösungen mit hunderten Issues wo probleme erwähnt werden
Erlaubt es einfach gute UI zu machen
Upload passiert nicht im Request zum Controller
Private Uploads

Funktioniert nur wenn du Dateien auf deinem Server hast.
Nichts für Gem Installier Programmierer die erwarten das ein Gem ihren UseCase ohne zusätzlichen Aufwand löst.



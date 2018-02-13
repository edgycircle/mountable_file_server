Mountable File Server can be used with any Ruby (on Rails) application and it removes the pain associated with file uploads.

## Core Idea
app only stores reference to uploaded file

## MountableFileServer::Server
The core of Mountable File Server (MFS) is a small HTTP API that accepts file uploads and offers endpoints to interact with uploaded files. While the frontend deals directly with the HTTP API, your Ruby application will want to use the Ruby Client `MountableFileServer::Client`.






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
As seen in the previous section there is a global configuration at `MountableFileServer.configuration` available.
This is an instance of the `MountableFileServer::Configration` class. The global configuration is a default argument for all classes that require access to the configuration. In situations where you have multiple endpoints with different settings you can pass in you own configuration objects instead.

The global configuration can be configured through a block.

~~~ruby
MountableFileServer.configure do |configuration|
  configuration.mounted_at = '/uploads'
  configuration.stored_at = '/path/to/desired/uploads/directory'
end
~~~

In order to build correct URLs for public files the `mounted_at` attribute should be set to the path where the endpoint is mounted.

The `stored_at` attribute tells the MountableFileServer where to store uploaded files. It will automatically create this and all needed subdirectories. This directory should not be within the root of your webserver. Otherwise private files are accessible to the internet.

## Usage
The idea is to upload a file with AJAX rather than sending it with the usual form submit. After the upload, an unique identifier (`uid`), is added to the form as a hidden element. Instead of dealing with a file upload your application only has to store the `uid`, a simple string value.

Using the `MountableFileServer::Adapter` your application can work with the uploaded file, the only thing needed is the `uid`.

## JavaScript API
On the JavaScript side you use `uploadFiles(element, files)` to upload files to the endpoint. The `element` argument is a DOM element that needs two data attributes. `data-endpoint` specifies where the AJAX request should be sent to, this probably matches the `mounted_at` configuration option. `data-type` tells the endpoint if the uploaded files should be treated as public or private files. Possible values are `public` or `private`.

The `files` argument is an array of `File` objects or an `FileList` object. These objects are for example returned when a user selects files using an `input` element.

Following events will be dispatched on the element that was passed to `uploadFiles`. When you are listening to one of these events you can access the described attributes on the `event.detail` object.

`upload:start` is dispatched when the upload starts.
It has the attributes `uploadId` and `file`. The `uploadId` is local and can be used to identify events in a scenario where multiple files are uploaded. The `file` attribute is the original `File` object and useful for showing a preview or other information about the file.

`upload:progress` is continuously dispatched while the upload is happening.
It has the attributes `uploadId` and `progress`. The `progress` attribute is the original [ProgressEvent](https://developer.mozilla.org/en-US/docs/Web/API/ProgressEvent) object of the AJAX request.

`upload:success` is dispatched when the upload succeeded.
It has the attributes `uploadId`, `uid` and `wasLastUpload`. The `uid` attribute is the unique identifier generated by the MountableFileServer. You will want to add it to your form and store it along your other data. The `wasLastUpload` attribute indicates if this was the last upload in progress.

## Ruby API
The `MountableFileServer::Adapter` class allows you to interact with uploaded files. It takes a `MountableFileServer::Configuration` instance as argument and uses `MountableFileServer.configuration` by default.

`MountableFileServer::Adapter#store_temporary(input, type, extension)`
Stores the input as file in the temporary storage and returns the `uid` of the file. `input` can be a path to a file or an [IO](http://ruby-doc.org/core-2.2.2/IO.html) object. `type` can be `public` or `private` and the `extension` argument specifies the extension the file should have.

`MountableFileServer::Adapter#store_permanent(input, type, extension)`
Stores the input as file in the permanent storage and returns the `uid` of the file. `input` can be a path to a file or an [IO](http://ruby-doc.org/core-2.2.2/IO.html) object. `type` can be `public` or `private` and the `extension` argument specifies the extension the file should have.

`MountableFileServer::Adapter#move_to_permanent_storage(uid)`
Moves a file from the temporary storage to the permanent one. This is mostly used in a scenario where users upload files. A file uploaded through the endpoint is initially only stored in the temporary storage. The application has to move it explicitly to the permanent storage. For example after all validations passed.

`MountableFileServer::Adapter#remove_from_permanent_storage(uid)`
Removes the file from the permanent storage.

`MountableFileServer::Adapter#url_for(uid)`
Returns the URL for an uploaded file. Only works for public files, if you pass the `uid` of a private file an error will be raised.

`MountableFileServer::Adapter#pathname_for(id)`
Returns a [Pathname](http://ruby-doc.org/stdlib-2.2.2/libdoc/pathname/rdoc/Pathname.html) object for the uploaded file. The pathname will always point to the file on disk independent from the files type or current storage location.

# Development
Run the migrations of the Ruby on Rails dummy application to make sure you can run the tests: `cd test/rails-dummy && RAILS_ENV=test bundle exec rake db:migrate`.

Run tests with `bundle exec rake test`.

# Publish on RubyGems.org

1. Increment `lib/mountable_image_server/version.rb` to your liking.
2. Make a Git commit.
3. Run `bundle exec rake release`.

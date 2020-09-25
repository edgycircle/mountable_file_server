# 3.0.2
* Fix deprecation warning when calling metadata class initializer with keyword arguments.
* Don't break when uploading a private file.

# 3.0.1
* Repair broken `FileAccessor` class.

# 3.0.0
* **Breaking Change**: Remove `MountableFileServer::Client`. Use `MountableFileServer::Adapter` instead.

# 2.1.0
* Relax Sinatra dependency so Ruby on Rails 4 can use Rack 1.X

# 2.0.0
* Remove HTTP endpoints for moving and deleting uploads due to security concerns.
* Return 404 for unknown or malformed FIDs.

# 0.0.2 - 24.08.2015
* Internal refactorings.
* Introduce `Adapter` class to have one point of contact.

**Breaking Changes**
* Files are stored under their full unique identifier in every storage.
* Remove `Access` class.
* Signature of `Storage` methods changed.

The fundamental idea is that your application only deals with identifiers of uploaded files in string form. No need to handle files directly. It should not complicate testing. It should allow files that are publicly accessible and private files that are not. Uploads happen via Ajax without additional work on the application developers side. It allows easy customization and adaption of the file upload process on the frontend to give a good user experience.









# MountableFileServer

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mountable_file_server'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mountable_file_server

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mountable_file_server/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

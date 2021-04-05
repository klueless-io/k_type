# K Type

> K Type provides base types for KlueLess code generation

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'k_type'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install k_type
```

## Stories

### Main Story

As a Platform, I need DRY/SRP types, so that the system maintains loose coupling

See all [stories](./STORIES.md)

## Usage

See all [usage examples](./USAGE.md)

### Basic Example

#### Layered Folder

Layered folders allow files to be found in any of the searchable folders, it uses a &#x60;LIFO&#x60; stack (&quot;Last-In, First-Out&quot;)

```ruby
base_folder = '/dev'

app_template_folder = File.join(base_folder, 'app-template')
domain_template_folder = File.join(base_folder, 'domain-template')
global_template_folder = File.join(base_folder, 'global-template')

folders = KType::LayeredFolders.new

folders.add(:fallback, '~/x')
folders.add(:global, global_template_folder)
folders.add(:domain, domain_template_folder)
folders.add(:app, app_template_folder)
folders.add(:app_abc, :app, 'a', 'b', 'c')

# Find a file in one of the following folders, searches in the following order (LIFO)
#
# "/dev/app-template/a/b/c"
# "/dev/app-template"
# "/dev/domain-template"
# "/dev/global-template"
# "/Users/username/x"
folders.find_file('template1.txt')

# Get the folder that the file is found in
#
folders.find_file_folder('template1.txt') # > /dev/app-template
```

#### Named Folder

Named folders allow folders to be stored with easy to remember names and alias&#x27;s

```ruby
folders = KType::NamedFolders.new

folders.add(:app, '/dev/MyApp')
folders.add(:config, :app, 'config')
folders.add(:docs, '~/documentation')

# Creates named folders
#
# "/dev/MyApp"
# "/dev/MyApp/config"
# "/Users/username/documentation"

# Get filename

folders.get_filename(:app, 'Program.cs') # > '/dev/MyApp/Program.cs'

folders.get_filename(:config, 'webpack.json') # > '/dev/MyApp/config/webpack.json'

folders.get_filename(:app, 'Models', 'Person.cs') # > '/dev/MyApp/Models/Person.cs'

# Get folder

folders.get(:config) # > '/dev/MyApp/config'
```

## Development

Checkout the repo

```bash
git clone klueless-io/k_type
```

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

`k_type` is setup with Guard, run `guard`, this will watch development file changes and run tests automatically, if successful, it will then run rubocop for style quality.

To release a new version, update the version number in `version.rb`, build the gem and push the `.gem` file to [rubygems.org](https://rubygems.org).

```bash
rake publish
rake clean
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/klueless-io/k_type. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the K Type project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/klueless-io/k_type/blob/master/CODE_OF_CONDUCT.md).

## Copyright

Copyright (c) David Cruwys. See [MIT License](LICENSE.txt) for further details.

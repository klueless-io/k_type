# K Type

> K Type provides base types for KlueLess code generation

As a Platform, I need DRY/SRP types, so that the system maintains loose coupling

## Usage

### Sample Classes

#### Layered Folder

Layered folders allow files to be found in any of the searchable folders, it uses a `LIFO` stack ("Last-In, First-Out")

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

Named folders allow folders to be stored with easy to remember names and alias's

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

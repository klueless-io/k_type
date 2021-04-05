# frozen_string_literal: true

module KType
  # Named folders allow folders to be stored with easy to remember names/alias's
  # Secondarily, you can also build up file names based on these named folders.
  #
  # Named folders makes sense for generated/output folders because you may want
  # more than one type of location to generate output.
  #
  # Don't confuse multiple named output folders with sub-paths, when you want to
  # build up a file name in a child folder, you can do that as part of building
  # the filename.
  #
  # The idea behind named folders is for when you have two or more totally different
  # outputs that (may live in the a similar location) or live in different locations.
  # Samples:
  #   name: :code       - generating source code into a project
  #   name: :slide      - generating slide deck into a documentation folder
  #   name: :webpack    - folder where you might generate webpack files, e.g. webpack.config.*.json
  #
  # example:
  #   folders = NamedFolders.new
  #   folders.add(:csharp       , '~/dev/csharp/cool-project')
  #   folders.add(:package_json , :csharp)
  #   folders.add(:webpack      , folders.join(:csharp, 'config'))
  #   folders.add(:builder      , folders.join(:csharp, 'builder'))
  #   folders.add(:slides       , '~/doc/csharp/cool-project')
  #
  #   puts folders.get(:builder)
  #
  #   puts folders.get_filename(:csharp, 'Program.cs')
  #   puts folders.get_filename(:csharp, 'Models/Order.cs')
  #   puts folders.get_filename(:csharp, 'Models', 'Order.cs')
  #
  # Do I need to support :default?
  class NamedFolders
    attr_reader :folders

    attr_reader :current

    def initialize
      @folders = {}
      @current = nil
    end

    def initialize_copy(orig)
      super(orig)

      @folders = orig.folders.clone
    end

    def current=(folder_key)
      guard_folder_key(folder_key)
      @current = folder_key
    end

    # Add support for file_parts
    def add(folder_key, *folder_parts)
      # get a predefined folder by symbol
      folder = join_folder_parts(folder_parts)
      if folder.is_a?(Symbol)
        folder = get(folder)
      elsif folder.start_with?('~')
        folder = File.expand_path(folder)
      end

      @current = folder_key if @current.nil?
      folders[folder_key] = folder
    end

    # Get a folder
    def get(folder_key)
      guard_folder_key(folder_key)
      folders[folder_key]
    end

    # Join the lookup folder key with the subpath folder parts (optionally + filename) and return the folder or filename
    #
    # Return fully qualified filename
    def join(folder_key, *file_folder_parts)
      folder = get(folder_key)

      File.join(folder, file_folder_parts)
    end
    # Get a file name using the lookup folder key and the file name or array of sub-paths plus filename
    alias get_filename join

    def folder_keys
      @folders.keys
    end

    def to_h
      @folders
    end

    private

    def join_folder_parts(folder_parts)
      raise KType::Error, 'No folder part provided' if folder_parts.nil? || folder_parts.length.zero?

      # If only one part, and that can be a folder or :folder_key, then just return it
      return folder_parts.first if folder_parts.length == 1

      folder_parts = folder_parts.map.with_index do |folder_part, index|
        folder_part = get(folder_part) if index.zero? && folder_part.is_a?(Symbol)
        folder_part
      end

      File.join(folder_parts)
    end

    def guard_folder_key(folder_key)
      raise KType::Error, "Folder not found, this folder key not found: #{folder_key}" unless folders.key?(folder_key)
    end
  end
end

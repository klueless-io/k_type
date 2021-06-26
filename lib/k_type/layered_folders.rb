# frozen_string_literal: true

module KType
  # Layered folders allow files to be found in any of the searchable folders
  #
  # They derive from and thus work just like named folders in that they allow folders
  # to be stored with easy to remember names/alias's.
  #
  # Where they differ is that they are retrieved in preferential search order that is
  # by default (First In, Last Out) priority aka a Stack (Last In, First Out) or
  # optionally over ridden via the search_order method
  #
  # Layered folders makes sense for use with template files and source data/model
  # where you can have specific usage files available and if they are not found then
  # you can use fall-back files in other folders.
  #
  # example:
  #   folders = LayeredFolders.new
  #   folders.add(:global       , '~/global_templates')
  #   folders.add(:domain       , '/my-project/domain_templates')
  #   folders.add(:app          , '/my-project/my-app/.templates')
  #
  #   # Find a file and folder will in folders in this order
  #   # app_templates, then domain_templates and then finally global templates
  #   # ['/my-project/my-app/.templates', '/my-project/domain_templates', '~/global_templates']
  #   #
  #   # Find a file called template1.txt and return its fully-qualified path
  #   folders.find_file('template1.txt')
  #
  #   # As above, but returns the folder only, file name and sub-paths are ignored
  #   folders.find_file_folder('template1.txt')
  #   folders.find_file_folder('abc/xyz/deep-template.txt')
  #
  #   # If an additional folder is added, say in child configuration that is designed
  #   # to override some of the global templates, then you can run a search_order
  #   # method to re-order the templates
  #
  #   folders.add(:global_shim  , '~/global_templates_shim')
  #   folders.search_order(:app, :domain, :global_shim, :global)
  #
  # class Builder < KType::BaseBuilder
  class LayeredFolders < KType::NamedFolders
    attr_reader :ordered_keys
    attr_reader :ordered_folders

    def initialize
      super()

      @ordered_keys = []
      @ordered_folders = []
    end

    def initialize_copy(orig)
      super(orig)

      @ordered_keys = orig.ordered_keys.clone
      @ordered_folders = orig.ordered_folders.clone
    end

    def add(folder_key, *folder_parts)
      folder = super(folder_key, *folder_parts)

      index = ordered_keys.find_index(folder_key)
      if index
        ordered_folders[index] = folder
      else
        ordered_keys.prepend(folder_key)
        ordered_folders.prepend(folder)
      end

      folder
    end

    # File name or array of sub-paths plus file
    #
    # Return the folder that a file is found in
    def find_file(file_parts)
      folder = find_file_folder(file_parts)
      folder.nil? ? nil : File.join(folder, file_parts)
    end

    # File name or array of sub-paths plus file
    #
    # Return the folder that a file is found in
    def find_file_folder(file_parts)
      ordered_folders.find { |folder| File.exist?(File.join(folder, file_parts)) }
    end

    def to_h
      {
        ordered: {
          keys: ordered_keys,
          folders: ordered_folders
        }
      }.merge(@folders)
    end


    def debug(title: 'layered folders')
      log.section_heading title

      ordered_keys.each do |key|
        folder = folders[key]
        log.kv key.to_s, folder
      end
    end
  end
end

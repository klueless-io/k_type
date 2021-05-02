# frozen_string_literal: true

require 'k_type/version'
require 'k_type/named_folders'
require 'k_type/layered_folders'

module KType
  # raise KType::Error, 'Sample message'
  class Error < StandardError; end

  # Your code goes here...
end

if ENV['KLUE_DEBUG']&.to_s&.downcase == 'true'
  namespace = 'KType::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('k_type/version') }
  version   = KType::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end

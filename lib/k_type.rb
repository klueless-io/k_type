# frozen_string_literal: true

require 'k_log'
require 'k_type/version'
require 'k_type/composite'
require 'k_type/named_folders'
require 'k_type/layered_folders'

module KType
  # raise KType::Error, 'Sample message'
  class Error < StandardError; end
end

if ENV.fetch('KLUE_DEBUG', 'false').downcase == 'true'
  namespace = 'KType::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('k_type/version') }
  version   = KType::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end

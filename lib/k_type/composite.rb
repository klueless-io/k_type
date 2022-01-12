# frozen_string_literal: true

# TODO: future
# This pattern would be great as a configurable generic class
#
# children could be renamed as:
# - directors
# - components
# - elements
#
# It may also be relevant to separate parent form children

# Parent director allows upwards navigation
# attr_reader :parent
# Children directors allow downwards navigation plus access to sub-directors
# attr_reader :children

module KType
  # Composite Design Pattern: https://refactoring.guru/design-patterns/composite
  module Composite
    # Parent allows upwards navigation to components
    attr_reader :parent

    # Children allow downwards navigation plus access to sub-components
    attr_reader :children

    def attach_parent(parent)
      @parent = parent
    end

    def navigate_parent
      parent.nil? ? self : parent
    end

    def root?
      parent.nil?
    end

    # Implement as needed (Implement is not provided here because you may want to use hash or array and have additional logic)
    # def reset_children
    # end
    # def add_child
    # end
    # def remove_child
    # end
    # def get_children
    # end
    # def has_child?
    # end
    # def execute
    # end
  end
end

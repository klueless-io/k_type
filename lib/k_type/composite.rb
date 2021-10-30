# frozen_string_literal: true

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

    def navigate_up
      parent.nil? ? self : parent
    end

    def root?
      parent.nil?
    end

    # Implement as needed (Implement is not provided here because you may want to use hash or array and have additional logic)
    # def add_component
    # end
    # def remove_component
    # end
    # def get_childern
    # end
    # def execute
    # end
  end
end

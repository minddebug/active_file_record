require 'active_support/core_ext/array'
require 'active_support/core_ext/hash/except'
require 'active_support/core_ext/kernel/singleton_class'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/class/attribute'

module ActiveFileRecord
  # = Active Record Named \Scopes
  module Scoping
    module Named
      extend ActiveSupport::Concern

      module ClassMethods

        def scoped(options = nil)

          if options
            scoped.apply_finder_options(options)
          else
            if current_scope
              current_scope.clone
            else
              scope = relation
              scope.default_scoped = true
              scope
            end
          end
        end

        def scope_attributes # :nodoc:
          if current_scope
            current_scope.scope_for_create
          else
            scope = relation
            scope.default_scoped = true
            scope.scope_for_create
          end
        end

        def scope_attributes? # :nodoc:
          current_scope || default_scopes.any?
        end

        def scope(name, scope_options = {})
          name = name.to_sym
          valid_scope_name?(name)
          extension = Module.new(&Proc.new) if block_given?

          scope_proc = lambda do |*args|
            options = scope_options.respond_to?(:call) ? unscoped { scope_options.call(*args) } : scope_options
            options = scoped.apply_finder_options(options) if options.is_a?(Hash)

            relation = scoped.merge(options)

            extension ? relation.extending(extension) : relation
          end

          singleton_class.send(:redefine_method, name, &scope_proc)
        end

      protected

        def valid_scope_name?(name)
          if logger && respond_to?(name, true)
            logger.warn "Creating scope :#{name}. " \
                        "Overwriting existing method #{self.name}.#{name}."
          end
        end
      end
    end
  end
end

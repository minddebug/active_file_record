require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/conversions'
require 'active_support/core_ext/module/remove_method'
require 'active_support/core_ext/class/attribute'

module ActiveFileRecord
  module Associations
    extend ActiveSupport::Autoload
      extend ActiveSupport::Concern

      autoload :Association
      autoload :SingularAssociation
      autoload :BelongsToAssociation

      module Builder
        autoload :Association,           'active_file_record/associations/builder/association'
        autoload :SingularAssociation,   'active_file_record/associations/builder/singular_association'
        autoload :BelongsTo,           'active_file_record/associations/builder/belongs_to'
      end

      eager_autoload do
        autoload :AssociationScope, 'active_file_record/associations/association_scope'
      end

      attr_reader :association_cache

      def association(name)
        association = association_instance_get(name)
        if association.nil?
          reflection  = self.class.reflect_on_association(name)
          association = reflection.association_class.new(self, reflection)
          association_instance_set(name, association)
        end

        association
      end

      private
      def association_instance_get(name)
        @association_cache[name.to_sym]
      end

      def association_instance_set(name, association)
        @association_cache[name] = association
      end

      module ClassMethods
        def belongs_to(name, options = {})
            Builder::BelongsTo.build(self, name, options)
        end
      end

  end
end

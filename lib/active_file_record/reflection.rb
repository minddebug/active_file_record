require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/object/inclusion'

module ActiveFileRecord
  module Reflection
    extend ActiveSupport::Concern

    included do
      class_attribute :reflections
      self.reflections = {}
    end

    module ClassMethods
      def create_reflection(macro, name, options, active_file_record)
            klass = options[:through] ? ThroughReflection : AssociationReflection
            reflection = klass.new(macro, name, options, active_file_record)

        self.reflections = self.reflections.merge(name => reflection)
        reflection
      end

      def reflect_on_association(association)
        reflections[association].is_a?(AssociationReflection) ? reflections[association] : nil
      end
    end

    class MacroReflection
      attr_reader :name
      attr_reader :macro
      attr_reader :options
      attr_reader :active_file_record

      def initialize(macro, name, options, active_file_record)
        @macro         = macro
        @name          = name
        @options       = options
        @active_file_record = active_file_record
      end

      def klass
        @klass ||= class_name.constantize
      end

      def class_name
        @class_name ||= (options[:class_name] || derive_class_name).to_s
      end

      private
        def derive_class_name
          name.to_s.camelize
        end
    end

    class AssociationReflection < MacroReflection #:nodoc:
      def klass
        @klass ||= active_file_record.send(:compute_type, class_name)
      end

      def initialize(macro, name, options, active_record)
        super
        @collection = macro.in?([:has_many, :has_and_belongs_to_many])
      end

      def build_association(*options, &block)
        klass.new(*options, &block)
      end

      def foreign_key
        @foreign_key ||= options[:foreign_key] || derive_foreign_key
      end

      def foreign_type
        @foreign_type ||= options[:foreign_type] || "#{name}_type"
      end

      def type
        @type ||= options[:as] && "#{options[:as]}_type"
      end

      def primary_key_column
        @primary_key_column ||= klass.columns.find { |c| c.name == klass.primary_key }
      end

      def association_foreign_key
        @association_foreign_key ||= options[:association_foreign_key] || class_name.foreign_key
      end

      def association_primary_key(klass = nil)
        options[:primary_key] || primary_key(klass || self.klass)
      end

      def chain
        [self]
      end

      def nested?
        false
      end

      def conditions
        [[options[:conditions]].compact]
      end

      alias :source_macro :macro

      def has_inverse?
        @options[:inverse_of]
      end

      def inverse_of
        if has_inverse?
          @inverse_of ||= klass.reflect_on_association(options[:inverse_of])
        end
      end

      def collection?
        @collection
      end

      # Returns +true+ if +self+ is a +belongs_to+ reflection.
      def belongs_to?
        macro == :belongs_to
      end

      def association_class
        Associations::BelongsToAssociation
      end

      private
        def derive_foreign_key
            "#{name}_id"
        end

        def primary_key(klass)
          klass.primary_key || raise(UnknownPrimaryKey.new(klass))
        end
    end

  end
end

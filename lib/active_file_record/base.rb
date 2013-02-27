require 'active_support/core_ext/module/delegation'

module ActiveFileRecord

  class MissingAttributeError < NoMethodError
  end

  class RecordNotFound < Exception
  end

  class Base
    include Criteria
    include Persistence
    include Validations
    include Callbacks
    include AttributeAssignment
    include AttributeMethods
    include Associations
    extend Criteria
    include Scoping
    include Inheritance
    include Reflection
    include Integration

    extend ActiveModel::Naming

    fields :id

    attr_reader :attributes, :new_record, :destroyed
    attr_accessor :filename


    def initialize(attributes = nil,  options = {})
      @new_record = true
      @destroyed = false
      @attributes = self.class.initialize_attributes(self.class._fields.dup)
      @association_cache = {}
      assign_attributes(attributes, options) if attributes
    end

    def init_with(attributes = nil)
      @association_cache = {}
      @attributes = self.class.initialize_attributes(self.class._fields.dup)
      assign_attributes(attributes, {:without_protection => true}) if attributes
      @new_record = false
      @destroyed = false
      self
    end

    class << self
      def filename
        @filename ||= self.name.underscore
      end

      def filename=(name)
        @filename = name
      end

      def primary_key
        :id
      end

      def generated_feature_methods
        @generated_feature_methods ||= begin
          mod = const_set(:GeneratedFeatureMethods, Module.new)
          include mod
          mod
        end
      end

      def file_handler
        @file_handler ||= FileHandler.new(filename)
      end

      def relation
        relation = Relation.new(self, file_handler)
      end
    end

  end
end
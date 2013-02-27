module ActiveFileRecord
  module AttributeMethods

    extend ActiveSupport::Concern
    include ActiveModel::AttributeMethods

    included do
      include Read
      include Write

      class_attribute :_fields
      self._fields = []

      def [](attr_name)
        read_attribute(attr_name)
      end

      def []=(attr_name, value)
        write_attribute(attr_name, value)
      end
    end

    def attribute_names
      @attributes.keys
    end


    module ClassMethods
      def fields(*names)
        self._fields += names
        define_attribute_methods names
      end

      def initialize_attributes(fields_names)
        Hash[fields_names.map {|attribute| [attribute, nil]}]
      end

      def generated_methods
        @generated_methods ||= begin
        mod = Module.new
        include(mod)
          mod
        end
      end
    end

  end
end
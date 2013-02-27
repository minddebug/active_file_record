module ActiveFileRecord
  module AttributeMethods
    module Read
      extend ActiveSupport::Concern
      include ActiveModel::AttributeMethods

      included do
        attribute_method_prefix ""
      end

      module ClassMethods
        def define_method_attribute(attr_name)
          generated_attribute_methods.send(:define_method, "#{attr_name}") do
            read_attribute(attr_name.to_s)
          end
        end
      end

      def read_attribute(attr_name)
        attr_name = attr_name.to_sym
        @attributes[attr_name]
      end

    end
  end
end
module ActiveFileRecord
  module AttributeMethods
    module Write
      extend ActiveSupport::Concern
      include ActiveModel::AttributeMethods

      included do
        attribute_method_suffix "="
      end

      module ClassMethods
        protected
        def define_method_attribute=(attr_name)
          generated_attribute_methods.send(:define_method, "#{attr_name}=") do |new_value|
            write_attribute(attr_name, new_value)
          end
        end
      end

      def write_attribute(attr_name, value)
        attr_name = attr_name.to_sym
        @attributes[attr_name] = value
      end

    end
  end
end
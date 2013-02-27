module ActiveFileRecord
  class PredicateBuilder # :nodoc:
    def self.build_from_hash(attributes, default_file)
      file = default_file

      # FIXME: We need to sanitize attributes

      predicates = attributes.map do |field, value|
        active_file = ActiveFile.new(file)
        attribute = active_file[field.to_sym]

        compare_method = value.keys.first
        attr_value = value.values.first

        attribute.send(compare_method, attr_value)
      end

      predicates.flatten
    end
  end
end
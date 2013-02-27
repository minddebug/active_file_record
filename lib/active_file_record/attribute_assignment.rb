module ActiveFileRecord
  module AttributeAssignment

    extend ActiveSupport::Concern
    include ActiveModel::MassAssignmentSecurity

    def attributes=(new_attributes)
      return unless new_attributes.is_a?(Hash)

      assign_attributes(new_attributes)
    end

    def assign_attributes(new_attributes, options = {})
      return if new_attributes.blank?

      attributes = new_attributes.stringify_keys
      attributes = sanitize_for_mass_assignment(attributes) unless options[:without_protection]

      attributes.each do |k, v|
        send("#{k}=", v)
      end
    end

  end
end
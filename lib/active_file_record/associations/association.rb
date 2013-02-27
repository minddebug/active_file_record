require 'active_support/core_ext/array/wrap'
require 'active_support/core_ext/object/inclusion'

module ActiveFileRecord
  module Associations

    class Association
      attr_reader :owner, :target, :reflection
      delegate :options, :to => :reflection

      def initialize(owner, reflection)
        #reflection.check_validity!

        @target = nil
        @owner, @reflection = owner, reflection
        @updated = false

        reset
        reset_scope
      end

      def reset
        @loaded = false
        @target = nil
      end

      def reset_scope
        @association_scope = nil
      end

      def reload
        reset
        reset_scope
        load_target
        self unless target.nil?
      end

      def klass
        reflection.klass
      end

      def scoped
        target_scope.merge(association_scope)
      end

      def target_scope
        klass.scoped
      end

      def association_scope
        if klass
          @association_scope ||= AssociationScope.new(self).scope
        end
      end

      def set_inverse_instance(record)
        if record && invertible_for?(record)
          inverse = record.association(inverse_reflection_for(record).name)
          inverse.target = owner
        end
      end

      def inverse_reflection_for(record)
        reflection.inverse_of
      end

      def stale_target?
        loaded? && @stale_state != stale_state
      end

      def loaded?
        @loaded
      end

      def load_target
        if find_target?
          #begin
          #  if IdentityMap.enabled? && association_class && association_class.respond_to?(:base_class)
          #    @target = IdentityMap.get(association_class, owner[reflection.foreign_key])
          #  end
          #rescue NameError
          #  nil
          #ensure
          @target ||= find_target
          #end
        end

        loaded! unless loaded?
        target
        rescue ActiveFileRecord::RecordNotFound
        reset
      end

      def loaded!
        @loaded      = true
        @stale_state = stale_state
      end

    end
  end
end

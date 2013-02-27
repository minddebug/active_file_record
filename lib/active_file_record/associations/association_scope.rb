module ActiveFileRecord
  module Associations
    class AssociationScope

      attr_reader :association

      delegate :klass, :owner, :reflection, :to => :association
      delegate :chain, :conditions, :to => :reflection

      def initialize(association)
        @association   = association
      end

      def scope
        scope = klass.unscoped
        add_constraints(scope)
      end

      private

      def add_constraints(scope)
        key = reflection.association_primary_key
        foreign_key = reflection.foreign_key
        scope.where({key => {:eq => owner[foreign_key].to_i}})
      end

    end
  end
end

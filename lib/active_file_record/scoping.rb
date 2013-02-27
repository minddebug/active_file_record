require 'active_support/concern'

module ActiveFileRecord
  module Scoping
    extend ActiveSupport::Concern

    included do
      include Named
    end

    module ClassMethods

      def unscoped
        block_given? ? relation.scoping { yield } : relation
      end


      protected
      def current_scope #:nodoc:
        Thread.current["#{self}_current_scope"]
      end
      #
      def current_scope=(scope) #:nodoc:
        Thread.current["#{self}_current_scope"] = scope
      end
    end
  end
end

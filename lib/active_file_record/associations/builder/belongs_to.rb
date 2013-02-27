require 'active_support/core_ext/object/inclusion'

module ActiveFileRecord::Associations::Builder
  class BelongsTo < Association #< SingularAssociation #:nodoc:
    self.macro = :belongs_to

    def build
      reflection = super
      reflection
    end

  end
end

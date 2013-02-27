module ActiveFileRecord
  module Predications

    def eq other
      Nodes::Equality.new self, other
    end

  end
end
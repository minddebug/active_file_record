module ActiveFileRecord
  module Nodes
    class Equality < ActiveFileRecord::Nodes::Binary
      attr_reader :operator

      def operator; :== end
      alias :operand1 :left
      alias :operand2 :right
    end
  end
end

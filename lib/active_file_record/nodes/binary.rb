module ActiveFileRecord
  module Nodes
    class Binary
      attr_accessor :left, :right

      def initialize left, right
        @left  = left
        @right = right
      end

      def initialize_copy other
        super
        @left  = @left.clone if @left
        @right = @right.clone if @right
      end
    end

  end
end

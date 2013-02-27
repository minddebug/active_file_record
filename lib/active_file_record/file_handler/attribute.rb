module ActiveFileRecord
    class Attribute < Struct.new :relation, :name
      include ActiveFileRecord::Predications
    end
end
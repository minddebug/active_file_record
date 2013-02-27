module ActiveFileRecord
  class ActiveFile
    attr_accessor :filename

    def initialize(filename)
      @filename = filename
    end

    def [] name
      Attribute.new self, name
    end
  end
end
module ActiveFileRecord
  module Integration
    def to_param
      id && id.to_s
    end

    def to_key
      key = self.id
      [key] if key
    end

  end
end

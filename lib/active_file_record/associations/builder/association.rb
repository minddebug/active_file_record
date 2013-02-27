module ActiveFileRecord::Associations::Builder
  class Association
    class_attribute :macro

    attr_reader :model, :name, :options, :reflection

    def self.build(model, name, options)
      new(model, name, options).build
    end

    def initialize(model, name, options)
      @model, @name, @options = model, name, options
    end

    def mixin
      @model.generated_feature_methods
    end

    def build
      reflection = model.create_reflection(self.class.macro, name, options, model)
      define_accessors
      reflection
    end

    private

      def define_accessors
        define_readers
        define_writers
      end

      def define_readers
        name = self.name
        mixin.redefine_method(name) do |*params|
          association(name).reader(*params)
        end
      end

      def define_writers
        name = self.name
        mixin.redefine_method("#{name}=") do |value|
          association(name).writer(value)
        end
      end
  end
end

require 'active_support/core_ext/object/blank'

module ActiveFileRecord
  class Relation
    include SearchMethods, FinderMethods

    delegate :file_handler, :filename, :primary_key, :to => :klass

    MULTI_VALUE_METHODS = [:where]
    SINGLE_VALUE_METHODS = [:limit]

    attr_accessor :default_scoped

    attr_reader :file, :klass, :loaded
    attr_accessor :extensions, :default_scoped
    alias :loaded? :loaded


    def initialize(klass, file)
      @klass = klass
      @file = file

      @implicit_readonly = nil
      @loaded            = false
      @default_scoped    = false

      SINGLE_VALUE_METHODS.each {|v| instance_variable_set(:"@#{v}_value", nil)}
      MULTI_VALUE_METHODS.each {|v| instance_variable_set(:"@#{v}_values", [])}
      @extensions = []
      @create_with_value = {}
    end

    def inspect
      to_a.inspect
    end

    def to_a
        exec_queries
    end

    def exec_queries
      return @records if loaded?
      default_scoped = self
      @records = find_with_associations
      @loaded = true
      @records
    end

    def merge(r)
      return self unless r
      return to_a & r if r.is_a?(Array)

      merged_relation = clone
      merged_wheres = @where_values + r.where_values

      merged_relation.where_values = merged_wheres

      (Relation::SINGLE_VALUE_METHODS - [:lock, :create_with, :reordering]).each do |method|
        value = r.send(:"#{method}_value")
        merged_relation.send(:"#{method}_value=", value) unless value.nil?
      end

      # Apply scope extension modules
      merged_relation.send :apply_modules, r.extensions

      merged_relation
    end

    private :exec_queries


  end
end
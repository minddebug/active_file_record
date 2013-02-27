#require 'active_support/core_ext/array/wrap'
#require 'active_support/core_ext/object/blank'

module ActiveFileRecord
  module SearchMethods
    extend ActiveSupport::Concern

    attr_accessor :where_values, :limit_value

    def select
        relation = clone
        relation
    end

    def where(opts)
      return self if opts.blank?

      relation = clone
      relation.where_values += build_where(opts)
      relation
    end

    def limit(value)
      relation = clone
      relation.limit_value = value
      relation
    end

    private

    def build_where(opts)
      PredicateBuilder.build_from_hash(opts, filename)
    end


    def apply_modules(modules)
      unless modules.empty?
        @extensions += modules
        modules.each {|extension| extend(extension) }
      end
    end

    protected

    def find_with_associations
      relation = construct_relation_for_association_find
      rows = file_handler.select_all(relation)
    end

    def construct_relation_for_association_find
      result = self.class.new(@klass, file)
      result.default_scoped = default_scoped

      Relation::MULTI_VALUE_METHODS.each do |method|
        result.send(:"#{method}_values=", send(:"#{method}_values"))
      end

      Relation::SINGLE_VALUE_METHODS.each do |method|
        result.send(:"#{method}_value=", send(:"#{method}_value"))
      end

      relation = result.select
    end
  end
end
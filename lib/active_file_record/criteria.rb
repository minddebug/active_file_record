require 'active_support/core_ext/module/delegation'

module ActiveFileRecord
  module Criteria
    delegate :find, :first, :last, :all, :to => :scoped
    delegate :select, :where, :to => :scoped

    extend ActiveSupport::Concern
  end
end
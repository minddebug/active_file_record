require 'active_support'
require 'active_support/i18n'
require 'active_model'
require "active_file_record/version"

module ActiveFileRecord
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Base

    autoload :Scoping

    autoload :Criteria
    autoload :Validations
    autoload :Callbacks
    autoload :Persistence
    autoload :AttributeAssignment
    autoload :AttributeMethods
    autoload :Associations
    autoload :Sanitization
    autoload :Inheritance
    autoload :Integration
    autoload :Reflection
    autoload :Predications
    autoload :Nodes

    autoload :Relation
    autoload_under 'relation' do
      autoload :SearchMethods
      autoload :FinderMethods
      autoload :PredicateBuilder
    end

    autoload :FileHandler
    autoload_under 'file_handler' do
      autoload :Attribute
      autoload :ActiveFile
    end

  end

  module Scoping
    extend ActiveSupport::Autoload
      autoload :Named
  end

  module AttributeMethods
    extend ActiveSupport::Autoload

    eager_autoload do
      autoload :Read
      autoload :Write
    end
  end

end

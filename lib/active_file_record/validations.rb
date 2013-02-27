module ActiveFileRecord
  module Validations
    extend ActiveSupport::Concern
    include ActiveModel::Validations

    def save
      true
      valid? ? super : false
    end

  end
end
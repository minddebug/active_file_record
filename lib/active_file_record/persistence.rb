module ActiveFileRecord
  module Persistence
    extend ActiveSupport::Concern
    include ActiveModel::Serializers::JSON

    included do
      class_attribute :include_root_in_json
      self.include_root_in_json = false
    end

    def save
      create
    end

    def create
      self.id = generate_id
      self.class.file_handler.add_record(self)
    end

    def new_record?
      @new_record
    end

    def destroyed?
      @destroyed
    end

    # Returns if the record is persisted, i.e. it's not a new record and it was
    # not destroyed.
    def persisted?
      !(new_record? || destroyed?)
    end

    #def update
    #end

    #def destroy
    #end

    #def update_attributes(attributes)
      #@attributes.merge!(attributes)
      #sanitize_attributes
      #save
    #end

    private
    def generate_id
      last_entry = self.class.last
      last_entry ? last_entry.id + 1 : 1
    end

  end
end
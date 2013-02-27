class Book < ActiveFileRecord::Base
  belongs_to :author

  fields :name, :description, :author_id

  attr_protected :id
  attr_accessible :description, :name, :author_id

  validates_presence_of :author_id, :description, :name



end
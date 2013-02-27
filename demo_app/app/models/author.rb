class Author < ActiveFileRecord::Base

  fields :name

  attr_protected :id
  attr_accessible :name

  validates_presence_of :name

end

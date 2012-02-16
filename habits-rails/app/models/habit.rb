class Habit < ActiveRecord::Base
  belongs_to :user
  default_scope :order => 'position ASC'
  attr_accessible :name, :notes, :position
end
class Creature < ActiveRecord::Base
  belongs_to :area
  has_many :dropped_sources
end
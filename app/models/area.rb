class Area < ActiveRecord::Base
  DUNGEONS = [206,4120,3477,4494,4196,4415,4375,4264,1196,4272,4228,4809,4813,4820,4723,4100]
  RAIDS = [4603,4273,4493,4500,2159,3456,4812,4722]

  TYPES = ['Area','Dungeon','Raid']

  after_create :set_name

  def set_name
    self.name = AreaImporter.new(wowarmory_id).name
    save
  end
end

class AreaImporter
  attr_reader :name

  def initialize(wowarmory_id)
    require 'open-uri'
    doc = Nokogiri::HTML(open("http://www.wowhead.com/?zone=#{wowarmory_id}"))
    @name = doc.css('#main h1').text
  end
end

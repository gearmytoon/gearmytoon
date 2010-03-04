class Area < ActiveRecord::Base
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

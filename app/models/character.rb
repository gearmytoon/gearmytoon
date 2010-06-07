class Character < ActiveRecord::Base
  include Upgradable
  
  DEFAULT_LOCALE = 'us'
  LOCALES = [['US','us'],['EU','eu'],['CN','cn'],['TW','tw'],['KR','kr']]
  HORDE_RACES = ['orc', 'undead', 'troll', 'tauren', 'blood elf']
  ALLIANCE_RACES = ['dwarf', 'gnome', 'human', 'night elf', 'draenei']

  has_upgrades_from :frost, Proc.new{EmblemSource.from_emblem_of_frost}, :for => ['pve', 'pvp']
  has_upgrades_from :triumph, Proc.new{EmblemSource.from_emblem_of_triumph}, :for => ['pve', 'pvp']
  has_upgrades_from :heroic_dungeon, Proc.new{DroppedSource.from_dungeons}, :for => ['pve']
  has_upgrades_from :honor_point, Proc.new{HonorSource.all}, :for => ['pvp']
  has_upgrades_from :arena_point, Proc.new{ArenaSource.all}, :for => ['pvp']
  has_upgrades_from :wintergrasp_mark, Proc.new{EmblemSource.from_wintergrasp_mark_of_honor}, :for => ['pvp']
  has_upgrades_from :raid_25, Proc.new{DroppedSource.from_raids_25}, :for => ['pve']
  # has_upgrades_from :area, Proc.new{ |area| DroppedSource.from_area(area)}
  has_upgrades_from :raid_10, Proc.new{DroppedSource.from_raids_10}, :for => ['pve']
  acts_as_state_machine :initial => :new, :column => "status"

  state :new
  state :found
  state :does_not_exist
  event :loaded do
    transitions :to => :found, :from => [:new, :does_not_exist]
  end
  event :unable_to_load do
    transitions :to => :does_not_exist, :from => [:new, :found]
  end

  attr_accessor :dont_use_wow_armory

  named_scope :found, :conditions => {:status => "found"}
  named_scope :level_80, :conditions => {:level => "80"}

  belongs_to :wow_class
  has_many :character_items
  has_many :character_refreshes
  has_many :upgrades
  serialize :total_item_bonuses
  has_many :equipped_items, :through => :character_items, :source => :item
  has_many :user_characters
  has_many :subscribers, :through => :user_characters, :source => :subscriber
  has_friendly_id :name_and_realm_and_locale, :use_slug => true
  validates_uniqueness_of :name, :scope => [:realm, :locale]
  validates_presence_of :name
  validates_presence_of :realm
  validates_presence_of :locale

  delegate :name, :to => :wow_class, :prefix => true

  def name_and_realm_and_locale
    "#{name} #{realm} #{locale}"
  end

  def dps_for(item_bonuses, for_pvp)
    wow_class.stat_multipliers(primary_spec, for_pvp).inject(0) do |total_dps, relative_bonus_dps_value|
      stat_name, relative_dps_value = relative_bonus_dps_value
      total_dps += relative_dps_value * (item_bonuses[stat_name] ? item_bonuses[stat_name] : 0)
    end
  end

  def hard_caps
    wow_class.hard_caps
  end

  def faction
    return 'horde' if HORDE_RACES.include?(race.downcase)
    return 'alliance' if ALLIANCE_RACES.include?(race.downcase)
  end

  def paid?
    subscribers.map(&:active_subscriber?).any? || subscribers.map(&:free_access).any?
  end

  def refresh_in_background!
    Resque.enqueue(CharacterJob, self.character_refreshes.create!.id)
  end

  def character_item_on(slot_name)
    character_items.equipped_on(slot_name)
  end

  private
  def capitalize_name_and_realm
    self.name.try(:capitalize!)
    self.realm.try(:capitalize!)
  end
end

class AddSpellEffectsToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :spell_effects, :text
  end

  def self.down
    remove_column :items, :spell_effects
  end
end

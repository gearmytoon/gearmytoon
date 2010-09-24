module SpecsHelper
  def usable_slots_select(spec)
    slots = ItemImporter::SLOT_CONVERSION.values - ["Tabard", "Shirt", 'Projectile']
    mapped_slots = slots.map{|slot| [slot,spec_slot_path(spec, slot, :scope => params[:scope])]}
    mapped_slots = [["All",spec_path(spec.wow_class, spec)]] + mapped_slots
    select_options = options_for_select(mapped_slots, request.request_uri)
    select_tag :slot_select, select_options
  end
end
#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
# and items. The instance of this class is referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  include EBJB
  
  #--------------------------------------------------------------------------
  # * Determine if Weapon is Throwable
  #     weapon : weapon
  #--------------------------------------------------------------------------
  def item_can_throw?(weapon)
    return false unless weapon.is_a?(RPG::Weapon)
    return false if item_number(weapon) == 0
    return true
  end
  
end
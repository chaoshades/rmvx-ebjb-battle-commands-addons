#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias element_set
  #--------------------------------------------------------------------------
  alias element_set_bc_sword_rune element_set unless $@
  def element_set
    if sword_rune_affected?
      return @sword_rune_element_set
    else
      return element_set_bc_sword_rune
    end
  end

end

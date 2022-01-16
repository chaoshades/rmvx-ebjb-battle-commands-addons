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
  # * Get total Steal rate bonus
  #--------------------------------------------------------------------------
  def total_steal_rate_bonus()
    n = 0
    equips.compact.each { |item| n += item.steal_rate_bonus }
    return n
  end

end

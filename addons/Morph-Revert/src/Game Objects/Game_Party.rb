#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
# and items. The instance of this class is referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  
  #--------------------------------------------------------------------------
  # * Replace an Actor
  #     actor_id : actor ID
  #     index :
  #--------------------------------------------------------------------------
  def replace_actor(actor_id, index)
    if index > -1 and index < @actors.size and not @actors.include?(actor_id)
      @actors[index] = actor_id
      $game_player.refresh
    end
  end
  
end

#==============================================================================
# ** Game_Enemy
#------------------------------------------------------------------------------
#  This class handles enemy characters. It's used within the Game_Troop class
# ($game_troop).
#==============================================================================

class Game_Enemy < Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array containing the steal items
  attr_reader :steal_items
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias game_enemy_initialize_bc_steal initialize unless $@
  def initialize(index, enemy_id)
    game_enemy_initialize_bc_steal(index, enemy_id)
    if enemy.steal_items != nil
      @steal_items = enemy.steal_items.clone
    end
  end
  
end

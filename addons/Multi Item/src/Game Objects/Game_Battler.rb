#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set Multi Item
  #--------------------------------------------------------------------------
  def set_multi_item_actions(nbr)
    @multi_actions_kind = 2
    set_multi_actions(nbr)
  end
  
  #--------------------------------------------------------------------------
  # * Multi Item Determination
  #--------------------------------------------------------------------------
  def multi_item_actions?
    return (@multi_actions_kind == 2)
  end
  
end

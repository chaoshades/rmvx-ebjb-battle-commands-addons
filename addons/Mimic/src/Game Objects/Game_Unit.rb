#==============================================================================
# ** Game_Unit
#------------------------------------------------------------------------------
#  This class handles units. It's used as a superclass of the Game_Party and
# Game_Troop classes.
#==============================================================================

class Game_Unit
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Keeps reference to last action for Mimic battle command
  attr_accessor :last_action
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def valid_last_action?(battler)
    result = true
    if last_action.is_a?(Array)
      for action in last_action
        result &= (action.nil? ||
                   valid_skill_action?(action, battler) ||
                   valid_item_action?(action))
      end
    else
      result = (last_action.nil? ||
                valid_skill_action?(last_action, battler) ||
                valid_item_action?(last_action))
    end
    
    return result
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def valid_skill_action?(action, battler)
    return (!BATTLECOMMANDS_CONFIG::BC_MIMIC_NO_MP_COST && 
            action.skill? && battler.mp < battler.calc_mp_cost(action.skill))
  end
  private :valid_skill_action?

  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def valid_item_action?(action)
    return (BATTLECOMMANDS_CONFIG::BC_MIMIC_CONSUME_ITEM && 
            action.item? && !$game_party.has_item?(action.item))
  end
  private :valid_item_action?
  
end

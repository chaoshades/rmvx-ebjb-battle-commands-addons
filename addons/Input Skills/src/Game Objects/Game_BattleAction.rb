#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #--------------------------------------------------------------------------
  # * Set Failed Input Attack
  #--------------------------------------------------------------------------
  def set_failed_input
    @kind = 0
    @basic = 8
  end
  
  #--------------------------------------------------------------------------
  # * Failed input Attack Determination
  #--------------------------------------------------------------------------
  def failed_input?
    return (@kind == 0 and @basic == 8)
  end
  
  #--------------------------------------------------------------------------
  # * Create Target Array
  #--------------------------------------------------------------------------
  alias make_targets_bc_inputskills make_targets unless $@
  def make_targets
    if failed_input?
      return [battler]
    else
      return make_targets_bc_inputskills
    end
  end
   
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_inputskills? valid? unless $@
  def valid?
    return true if failed_input?
    return valid_bc_inputskills?
  end
  
end
#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #--------------------------------------------------------------------------
  # * Set Mimic Attack
  #--------------------------------------------------------------------------
  def set_mimic
    @kind = 0
    @basic = 13
  end
  
  #--------------------------------------------------------------------------
  # * Set Failed Mimic Attack
  #--------------------------------------------------------------------------
  def set_failed_mimic
    @kind = 0
    @basic = 14
  end
  
  #--------------------------------------------------------------------------
  # * Mimic Attack Determination
  #--------------------------------------------------------------------------
  def mimic?
    return (@kind == 0 and @basic == 13)
  end

  #--------------------------------------------------------------------------
  # * Failed Mimic Attack Determination
  #--------------------------------------------------------------------------
  def failed_mimic?
    return (@kind == 0 and @basic == 14)
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_mimic make_targets unless $@
  def make_targets
    if failed_mimic?
      return [battler]
    else
      return make_targets_bc_mimic
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_mimic determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.mimic?
      action_name = "Mimic"
    else
      action_name = determine_action_name_bc_mimic
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_mimic? valid? unless $@
  def valid?
    return true if mimic? 
    return true if failed_mimic? 
    return valid_bc_mimic?
  end
  
end
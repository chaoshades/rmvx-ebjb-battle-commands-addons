#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #--------------------------------------------------------------------------
  # * Set Steal Attack
  #--------------------------------------------------------------------------
  def set_steal
    @kind = 0
    @basic = 9
  end
  
  #--------------------------------------------------------------------------
  # * Set Mug Attack
  #--------------------------------------------------------------------------
  def set_mug
    @kind = 0
    @basic = 10
  end
  
  #--------------------------------------------------------------------------
  # * Steal Attack Determination
  #--------------------------------------------------------------------------
  def steal?
    return (@kind == 0 and @basic == 9)
  end
  
  #--------------------------------------------------------------------------
  # * Mug Attack Determination
  #--------------------------------------------------------------------------
  def mug?
    return (@kind == 0 and @basic == 10)
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_steal determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.steal?
      action_name = "Steal"
    elsif self.mug?
      action_name = "Mug"
    else
      action_name = determine_action_name_bc_steal
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_steal make_targets unless $@
  def make_targets
    if steal? || self.mug?
      return make_attack_targets
    else
      return make_targets_bc_steal
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_steal? valid? unless $@
  def valid?
    return true if steal? || self.mug?
    return valid_bc_steal?
  end
  
end
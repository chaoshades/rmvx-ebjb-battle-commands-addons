#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #--------------------------------------------------------------------------
  # * Set Jump Attack
  #--------------------------------------------------------------------------
  def set_jump
    @kind = 0
    @basic = 4
  end
  
  #--------------------------------------------------------------------------
  # * Jump Attack Determination
  #--------------------------------------------------------------------------
  def jump?
    return (@kind == 0 and @basic == 4)
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_jump determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.jump?
      action_name = "Jump"
    else
      action_name = determine_action_name_bc_jump
    end
    
    return action_name
  end
  
#~   #--------------------------------------------------------------------------
#~   # * Alias available_targets
#~   #--------------------------------------------------------------------------
#~   alias available_targets_bc_jump available_targets unless $@
#~   def available_targets
#~     if jump?
#~       return opponents_unit.existing_members
#~     else
#~       return available_targets_bc_jump
#~     end
#~   end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_jump make_targets unless $@
  def make_targets
    if jump?
      return make_attack_targets
    else
      return make_targets_bc_jump
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_jump? valid? unless $@
  def valid?
    return true if jump?
    return valid_bc_jump?
  end
  
end
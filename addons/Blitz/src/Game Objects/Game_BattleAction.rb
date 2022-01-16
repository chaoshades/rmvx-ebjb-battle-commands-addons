#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction

  #--------------------------------------------------------------------------
  # * Set Blitz Attack
  #--------------------------------------------------------------------------
  def set_blitz(skill_id)
    @kind = 0
    @basic = 6
    @skill_id = skill_id
  end
  
  #--------------------------------------------------------------------------
  # * Set Failed Blitz Attack
  #--------------------------------------------------------------------------
  def set_failed_blitz
    @kind = 0
    @basic = 7
  end
  
  #--------------------------------------------------------------------------
  # * Blitz Attack Determination
  #--------------------------------------------------------------------------
  def blitz?
    return (@kind == 0 and @basic == 6)
  end
  
  #--------------------------------------------------------------------------
  # * Failed Blitz Attack Determination
  #--------------------------------------------------------------------------
  def failed_blitz?
    return (@kind == 0 and @basic == 7)
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Object
  #--------------------------------------------------------------------------
  alias skill_bc_blitz skill unless $@
  def skill
    return blitz? ? $data_skills[@skill_id] : skill_bc_blitz
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_blitz make_targets unless $@
  def make_targets
    if blitz?
      return make_obj_targets(skill)
    elsif failed_blitz?
      return [battler]
    else
      return make_targets_bc_blitz
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_blitz determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.blitz?
      action_name = "Blitz"
    else
      action_name = determine_action_name_bc_blitz
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_blitz? valid? unless $@
  def valid?
    return true if blitz?
    return true if failed_blitz?
    return valid_bc_blitz?
  end
  
end
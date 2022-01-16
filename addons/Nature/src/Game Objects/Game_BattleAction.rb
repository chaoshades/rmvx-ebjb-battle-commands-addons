#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #--------------------------------------------------------------------------
  # * Set Nature Attack
  #--------------------------------------------------------------------------
  def set_nature(skill_id)
    @kind = 0
    @basic = 16
    @skill_id = skill_id
  end
  
  #--------------------------------------------------------------------------
  # * Set Failed Nature Attack
  #--------------------------------------------------------------------------
  def set_failed_nature
    @kind = 0
    @basic = 17
  end
  
  #--------------------------------------------------------------------------
  # * Nature Attack Determination
  #--------------------------------------------------------------------------
  def nature?
    return (@kind == 0 and @basic == 16)
  end
  
  #--------------------------------------------------------------------------
  # * Failed Nature Attack Determination
  #--------------------------------------------------------------------------
  def failed_nature?
    return (@kind == 0 and @basic == 17)
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Object
  #--------------------------------------------------------------------------
  alias skill_bc_nature skill unless $@
  def skill
    return nature? ? $data_skills[@skill_id] : skill_bc_nature
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_nature make_targets unless $@
  def make_targets
    if nature?
      return make_obj_targets(skill)
    elsif failed_nature?
      return [battler]
    else
      return make_targets_bc_nature
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_nature determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.nature?
      action_name = "Nature"
    else
      action_name = determine_action_name_bc_nature
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_nature? valid? unless $@
  def valid?
    return true if nature?
    return true if failed_nature?
    return valid_bc_nature?
  end
  
end
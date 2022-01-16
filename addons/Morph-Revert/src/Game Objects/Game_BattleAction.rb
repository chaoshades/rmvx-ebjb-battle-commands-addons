#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #--------------------------------------------------------------------------
  # * Set Morph Attack
  #--------------------------------------------------------------------------
  def set_morph(skill_id)
    @kind = 0
    @basic = 11
    @skill_id = skill_id
  end
  
  #--------------------------------------------------------------------------
  # * Set Revert Attack
  #--------------------------------------------------------------------------
  def set_revert
    @kind = 0
    @basic = 12
  end
  
  #--------------------------------------------------------------------------
  # * Morph Attack Determination
  #--------------------------------------------------------------------------
  def morph?
    return (@kind == 0 and @basic == 11)
  end
  
  #--------------------------------------------------------------------------
  # * Revert Attack Determination
  #--------------------------------------------------------------------------
  def revert?
    return (@kind == 0 and @basic == 12)
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Object
  #--------------------------------------------------------------------------
  alias skill_bc_morph skill unless $@
  def skill
    return morph? ? $data_skills[@skill_id] : skill_bc_morph
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_morph determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.morph?
      action_name = "Morph"
    elsif self.revert?
      action_name = "Revert"
    else
      action_name = determine_action_name_bc_morph
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_morph make_targets unless $@
  def make_targets
    if self.morph?
      return make_obj_targets(skill)
    elsif self.revert?
      return [battler]
    else
      return make_targets_bc_morph
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_morph? valid? unless $@
  def valid?
    return true if morph?
    return true if revert?
    return valid_bc_morph?
  end
  
end
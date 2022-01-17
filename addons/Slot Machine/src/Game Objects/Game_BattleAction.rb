#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #--------------------------------------------------------------------------
  # * Set Slot Machine Attack
  #--------------------------------------------------------------------------
  def set_slot_machine(skill_id)
    @kind = 0
    @basic = 18
    @skill_id = skill_id
  end
  
  #--------------------------------------------------------------------------
  # * Set Failed Slot Machine Attack
  #--------------------------------------------------------------------------
  def set_failed_slot_machine
    @kind = 0
    @basic = 19
  end
  
  #--------------------------------------------------------------------------
  # * Slot Machine Attack Determination
  #--------------------------------------------------------------------------
  def slot_machine?
    return (@kind == 0 and @basic == 18)
  end
  
  #--------------------------------------------------------------------------
  # * Failed Slot Machine Attack Determination
  #--------------------------------------------------------------------------
  def failed_slot_machine?
    return (@kind == 0 and @basic == 19)
  end

  #--------------------------------------------------------------------------
  # * Get Skill Object
  #--------------------------------------------------------------------------
  alias skill_bc_slot_machine skill unless $@
  def skill
    return slot_machine? ? $data_skills[@skill_id] : skill_bc_slot_machine
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_slot_machine make_targets unless $@
  def make_targets
    if slot_machine?
      return make_obj_targets(skill)
    elsif failed_slot_machine?
      return [battler]
    else
      return make_targets_bc_slot_machine
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_slot_machine determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.slot_machine?
      action_name = "Slot Machine"
    else
      action_name = determine_action_name_bc_slot_machine
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_slot_machine? valid? unless $@
  def valid?
    return true if slot_machine?
    return true if failed_slot_machine?
    return valid_bc_slot_machine?
  end
  
end
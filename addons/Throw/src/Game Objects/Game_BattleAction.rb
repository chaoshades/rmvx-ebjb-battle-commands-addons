#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # weapon ID
  attr_accessor :weapon_id
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set Throw Attack
  #--------------------------------------------------------------------------
  def set_throw(weapon_id)
    @kind = 0
    @basic = 5
    @weapon_id = weapon_id
  end
  
  #--------------------------------------------------------------------------
  # * Throw Attack Determination
  #--------------------------------------------------------------------------
  def throw?
    return (@kind == 0 and @basic == 5)
  end
  
  #--------------------------------------------------------------------------
  # * Get Throw Object
  #--------------------------------------------------------------------------
  def throw_weapon
    return throw? ? $data_weapons[@weapon_id] : nil
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_throw determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.throw?
      action_name = "Throw"
    else
      action_name = determine_action_name_bc_throw
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_throw make_targets unless $@
  def make_targets
    if throw?
      return make_attack_targets
    else
      return make_targets_bc_throw
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_throw? valid? unless $@
  def valid?
    return true if throw?
    return valid_bc_throw?
  end
  
end

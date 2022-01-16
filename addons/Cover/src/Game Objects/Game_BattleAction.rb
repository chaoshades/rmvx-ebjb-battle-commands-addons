#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #--------------------------------------------------------------------------
  # * Set Cover Attack
  #--------------------------------------------------------------------------
  def set_cover
    @kind = 0
    @basic = 15
  end
  
  #--------------------------------------------------------------------------
  # * Cover Attack Determination
  #--------------------------------------------------------------------------
  def cover?
    return (@kind == 0 and @basic == 15)
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_cover determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.cover?
      action_name = "Cover"
    else
      action_name = determine_action_name_bc_cover
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_cover? valid? unless $@
  def valid?
    return true if cover? 
    return valid_bc_cover?
  end
  
  #--------------------------------------------------------------------------
  # * Alias available_targets
  #--------------------------------------------------------------------------
  alias available_targets_bc_cover available_targets unless $@
  def available_targets
    if self.cover?
      targets = []
      targets += friends_unit.existing_members
      # Prevent Cover on self
      targets.delete(@battler)
      
      # Prevent Cover on a char that is already protected
      targets.each do |ally|
        targets.delete(ally) if ally.protected?
      end

      return targets
    else
      return available_targets_bc_cover
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_cover make_targets unless $@
  def make_targets
    if self.cover?
      return [available_targets[0]]
    else
      return make_targets_bc_cover
    end
  end
  
end
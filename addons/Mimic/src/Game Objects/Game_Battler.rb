#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler

  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////

  # 
  attr_accessor :override_no_mp_cost
  # 
  attr_accessor :override_consume_item
  # Needs to be able to set the action when using the Mimic battle command
  attr_writer :action
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////  

  #--------------------------------------------------------------------------
  # * Alias calc_mp_cost
  #--------------------------------------------------------------------------
  alias calc_mp_cost_bc_mimic calc_mp_cost unless $@
  def calc_mp_cost(skill)
    return 0 if !@override_no_mp_cost.nil? && @override_no_mp_cost == true
    return calc_mp_cost_bc_mimic(skill)
  end
  
  #--------------------------------------------------------------------------
  # * Alias consume_item?
  #--------------------------------------------------------------------------
  alias consume_item_bc_mimic? consume_item? unless $@
  def consume_item?
    return @override_consume_item unless @override_consume_item.nil?
    return consume_item_bc_mimic?
  end
  
end

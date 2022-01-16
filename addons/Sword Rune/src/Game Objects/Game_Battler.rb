#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # 
  attr_accessor :sword_rune_element_set
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  def sword_rune_affected?
    return state?(BATTLECOMMANDS_CONFIG::BC_SWORD_RUNE_STATE_ID) && 
           !@sword_rune_element_set.nil?
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructor
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_bc_sword_rune initialize unless $@
  def initialize
    @sword_rune_element_set = nil
    initialize_bc_sword_rune
  end  
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias add_state
  #--------------------------------------------------------------------------
  alias apply_state_changes_bc_rune_sword apply_state_changes unless $@
  def apply_state_changes(obj)
    if (obj.is_a?(RPG::Skill) && 
        BATTLECOMMANDS_CONFIG::BC_SWORD_RUNE_SKILLS_ID.include?(obj.id))
      @sword_rune_element_set = obj.element_set.dup
    end
    
    apply_state_changes_bc_rune_sword(obj)
  end
  
  #--------------------------------------------------------------------------
  # * Alias remove_state
  #--------------------------------------------------------------------------
  alias remove_state_bc_rune_sword remove_state unless $@
  def remove_state(state_id)
    if state_id == BATTLECOMMANDS_CONFIG::BC_SWORD_RUNE_STATE_ID
      @sword_rune_element_set = nil
    end
    remove_state_bc_rune_sword(state_id)
  end
  
end

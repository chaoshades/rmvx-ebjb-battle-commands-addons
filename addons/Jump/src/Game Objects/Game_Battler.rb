#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias ready_for_action?
  #--------------------------------------------------------------------------
  alias ready_for_action_bc_jump? ready_for_action? unless $@
  def ready_for_action?
    if full_stamina? && @battle_animation.is_jumping?
      ready = false
      
      if @temp_jump_count == nil
        if BATTLECOMMANDS_CONFIG::BC_RANDOM_JUMP_TURNS
          turns_to_add = rand(BATTLECOMMANDS_CONFIG::BC_JUMP_TURNS)
        else
          turns_to_add = BATTLECOMMANDS_CONFIG::BC_JUMP_TURNS
        end
        
        @temp_jump_count = self.turn_count + turns_to_add
      end
      
      self.empty_stamina
      self.increase_turn_count

      if self.turn_count >= @temp_jump_count
        ready = true
        @temp_jump_count = nil
      end
      
      return ready
    else
      return ready_for_action_bc_jump?
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_bc_jump initialize unless $@
  def initialize
    initialize_bc_jump
    @temp_jump_count = nil
  end
  
end

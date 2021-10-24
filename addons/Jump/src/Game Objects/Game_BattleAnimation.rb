#==============================================================================
# ** Game_BattleAnimation
#------------------------------------------------------------------------------
#  This class deals with the battles animations in battle. It is referenced by
# the Game_Battler and Game_Projectile classes.
#==============================================================================

class Game_BattleAnimation
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Checks if animation action is Jumping
  #--------------------------------------------------------------------------
  def is_jumping?
    return @animation_action == BATTLESYSTEM_CONFIG::BA_JUMP
  end
  
  #--------------------------------------------------------------------------
  # * Checks if animation action is Landing
  #--------------------------------------------------------------------------
  def is_landing?
    return @animation_action == BATTLESYSTEM_CONFIG::BA_LAND
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Do Jump animation
  #--------------------------------------------------------------------------
  def do_ani_jump
    @animation_loop = false
    set_action_ani(BATTLESYSTEM_CONFIG::BA_JUMP)
  end
  
  #--------------------------------------------------------------------------
  # * Do Land animation
  #--------------------------------------------------------------------------
  def do_ani_land
    @animation_loop = false
    set_action_ani(BATTLESYSTEM_CONFIG::BA_LAND)
  end
  
#~   #--------------------------------------------------------------------------
#~   # * Alias do_next_battle_animation
#~   #--------------------------------------------------------------------------
#~   alias do_next_battle_animation_bc_jump do_next_battle_animation unless $@
#~   def do_next_battle_animation
#~     case @animation_action
#~     when BATTLESYSTEM_CONFIG::BA_JUMP
#~       do_ani_stand
#~     when BATTLESYSTEM_CONFIG::BA_LAND
#~       do_ani_stand
#~     end
#~     do_next_battle_animation_bc_jump
#~   end
  
end
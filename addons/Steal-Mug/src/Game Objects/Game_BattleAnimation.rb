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
  # * Checks if animation action is Stealing
  #--------------------------------------------------------------------------
  def is_stealing?
    return @animation_action == BATTLESYSTEM_CONFIG::BA_STEAL
  end
  
  #--------------------------------------------------------------------------
  # * Checks if animation action is Mugging
  #--------------------------------------------------------------------------
  def is_mugging?
    return @animation_action == BATTLESYSTEM_CONFIG::BA_MUG
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Do Steal animation
  #--------------------------------------------------------------------------
  def do_ani_steal
    @animation_loop = false
    set_action_ani(BATTLESYSTEM_CONFIG::BA_STEAL)
  end
  
  #--------------------------------------------------------------------------
  # * Do Steal animation
  #--------------------------------------------------------------------------
  def do_ani_mug
    @animation_loop = false
    set_action_ani(BATTLESYSTEM_CONFIG::BA_MUG)
  end
  
  #--------------------------------------------------------------------------
  # * Alias do_next_battle_animation
  #--------------------------------------------------------------------------
  alias do_next_battle_animation_bc_steal do_next_battle_animation unless $@
  def do_next_battle_animation
    case @animation_action
    when BATTLESYSTEM_CONFIG::BA_STEAL
      do_ani_stand
    when BATTLESYSTEM_CONFIG::BA_MUG
      do_ani_stand
    end
    do_next_battle_animation_bc_steal
  end
  
end
#==============================================================================
# ** Game_Projectile
#------------------------------------------------------------------------------
#  This class deals with projectiles in battle.
#==============================================================================

class Game_Projectile
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # weapon ID
  attr_reader   :weapon_id
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_bc_throw initialize unless $@
  def initialize(battler, animation_id)
    initialize_bc_throw(battler, animation_id)
    
    if battler.action.throw?
      @battle_animation.ba_show_weapon.push(BATTLESYSTEM_CONFIG::BA_MOVE)
      @weapon_id = battler.action.weapon_id
    end
  end
  
end

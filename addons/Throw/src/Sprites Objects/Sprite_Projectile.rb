#==============================================================================
# ** Sprite_Projectile
#------------------------------------------------------------------------------
#  This sprite is used to display projectiles. It observes a instance of the
# Game_Projectile class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Projectile < Sprite_BattleAnimBase
  include EBJB
      
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Overrides the loop animation animation for weapon (contents are defined by the subclasses)
  #--------------------------------------------------------------------------
  def override_loop_animation_weapon
    if @projectile.weapon_id != nil && @projectile.weapon_id > 0
      weapon = $data_weapons[@projectile.weapon_id]
    end
    return weapon
  end

end

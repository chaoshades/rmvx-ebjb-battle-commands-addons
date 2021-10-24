#===============================================================================
# ** RPG::Actor Addon
#------------------------------------------------------------------------------
#  Addon functions 
#===============================================================================

class RPG::Actor
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get custom animation for throwable weapon
  #     weapon_id : weapon ID
  #--------------------------------------------------------------------------
  # GET
  def ani_throw_weapons(weapon_id=nil)
    if weapon_id == nil
      return BATTLESYSTEM_CONFIG::ACTOR_THROW_WEAPON_ANIMS[self.id]
    else
      return BATTLESYSTEM_CONFIG::ACTOR_THROW_WEAPON_ANIMS[self.id][weapon_id]
    end
  end
  
end

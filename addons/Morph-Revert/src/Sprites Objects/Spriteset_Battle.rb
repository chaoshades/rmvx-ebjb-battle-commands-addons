#==============================================================================
# ** Spriteset_Battle
#------------------------------------------------------------------------------
#  This class brings together battle screen sprites. It's used within the
# Scene_Battle class.
#==============================================================================

class Spriteset_Battle
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create Actor Sprite
  #     actor : 
  #     index : 
  #--------------------------------------------------------------------------
  def create_actor(actor, index)
    if index > -1 and index < @actor_sprites.size
      @actor_sprites[index].dispose
      @actor_sprites[index] = Sprite_Battler.new(@viewport1, actor)
      @actor_sprites[index].update
    end
  end
  
end

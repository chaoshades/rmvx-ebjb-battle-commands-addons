#==============================================================================
# ** BATTLESYSTEM_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleSystem_Config configuration
#==============================================================================

module EBJB
  
  module BATTLESYSTEM_CONFIG

    #------------------------------------------------------------------------
    # Battle Status related
    #------------------------------------------------------------------------
       
    # Y adjusment for the face images in the battle status window 
    #   syntax: Face filename => array for the eight indexes in a face file
    FACE_Y_ADJUST_IMAGES["Evil"] = [0, 0, 0, 0, 0, 0, 26, 0]
    
    #------------------------------------------------------------------------
    # Scene Battle related
    #------------------------------------------------------------------------
    
    # Actor Battler Settings
    #   syntax: actor_id => CustomBattler(width, height, move_speed, ba_show_weapon)
    ACTOR_BATTLER_SETTINGS[10] = CustomBattler.new(32, 32, 5)
    
    #------------------------------------------------------------------------
    # Battle Animations Definitions
    #------------------------------------------------------------------------
    
    # Actor Battle Action Animations definitions
    #   syntax: actor_id => {'type' => animation_id}
    #   Where 'type' is one of the IP modes above
    ACTOR_BA_ANIMS[10] = {
      BA_STAND    => 202, 
      BA_HURT     => 203, 
      BA_MOVE     => 204, 
      BA_ATTACK   => 205,
      BA_HIT_HIGH => 206,
      BA_HIT_MID  => 207,
      BA_HIT_LOW  => 208,
      BA_DEAD     => 209,
      BA_DEFEND   => 210,
      BA_REVIVE   => 211,
      BA_RUN      => 204,
      BA_DODGE    => 212,
      BA_SKILL    => 213,
      BA_ITEM     => 214,
      #BA_STATE   => 214,
      BA_VICTORY  => 215,
      BA_INTRO    => 216
    }
    
  end
end

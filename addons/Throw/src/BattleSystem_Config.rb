#==============================================================================
# ** BATTLESYSTEM_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleSystem_Config configuration
#==============================================================================

module EBJB
  
  module BATTLESYSTEM_CONFIG
    
    #------------------------------------------------------------------------
    # Battle Animations Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent Battle actions
    # BATTLE_ACTION = 10xx
    # 
    BA_THROW   = Utilities.generate_battle_action_uid("BA_THROW")
    
    # Actor Battle Action Animations definitions
    #   syntax: actor_id => {'type' => animation_id}
    #   Where 'type' is one of the IP modes above
    ACTOR_BA_ANIMS[1][BA_THROW] = 196

    # Actor Battler Settings
    #   syntax: actor_id => CustomBattler(width, height, move_speed, ba_show_weapon)
    ACTOR_BATTLER_SETTINGS[1].ba_show_weapon.push(BA_THROW)
    
    # Actor Weapon Animations definitions
    #   syntax: actor_id => {weapon_id => CustomAnim(animation_id, 'type'), ...}
    #   Where 'type' is one of the movement types above
    ACTOR_THROW_WEAPON_ANIMS = {
      1 => {1 => CustomAnim.new(nil, MOVE_STEPS, 0, 197),
            2 => CustomAnim.new(nil, MOVE_STEPS, 0, 197),
            3 => CustomAnim.new(nil, MOVE_STEPS, 0, 198)},
    }
    ACTOR_THROW_WEAPON_ANIMS.default = Hash.new(CustomAnim.new(nil, MOVE_STEPS))
    
  end
end

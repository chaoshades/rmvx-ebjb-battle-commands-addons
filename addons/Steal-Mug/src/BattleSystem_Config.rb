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
    BA_STEAL   = Utilities.generate_battle_action_uid("BA_STEAL")
    BA_MUG     = Utilities.generate_battle_action_uid("BA_MUG")
    
    # Actor Battle Action Animations definitions
    #   syntax: actor_id => {'type' => animation_id}
    #   Where 'type' is one of the IP modes above
    ACTOR_BA_ANIMS[1][BA_STEAL] = 199
    ACTOR_BA_ANIMS[1][BA_MUG] = 200

  end
end

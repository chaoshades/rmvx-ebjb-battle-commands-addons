#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Blitz Command related 
    #------------------------------------------------------------------------
    
    # Blitz Button Inputs Settings
    #   syntax: skill_id => array of inputs
    BC_BLITZ_BUTTON_INPUTS = {
      98 => [Input::LEFT,Input::RIGHT,Input::LEFT],
      99 => [Input::LEFT,Input::DOWN,Input::RIGHT],
      100 => [Input::LEFT,Input::UP,Input::RIGHT,Input::DOWN]
    }
    
    # Timer between inputs (in seconds)
    BLITZ_INPUT_TIMER = 1
    
    # Max time before ending the blitz inputs (in seconds)
    BLITZ_MAX_INPUT_TIME = 6
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_BLITZ = Utilities.generate_battle_command_uid("BC_BLITZ")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_BLITZ, BC_BLITZ, nil, false))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_BLITZ))
    
  end
end

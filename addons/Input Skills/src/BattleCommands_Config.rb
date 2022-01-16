#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  #==============================================================================
  # ** InputSkill_Command
  #------------------------------------------------------------------------------
  #  Represents an input skill battle command
  #==============================================================================

  class InputSkill_Command < Skill_Command
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Button inputs array
    attr_reader :button_inputs
    # Maximum time allowed for inputs
    attr_reader :button_time
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     id : id
    #     button_inputs : Array of button inputs to complete the battle command
    #     button_time :
    #--------------------------------------------------------------------------
    def initialize(skill_id, button_inputs, button_time)
      super(Utilities.generate_battle_command_uid("BC_INPUTSKILLS_"+skill_id.to_s), 
            skill_id)
      @button_inputs = button_inputs
      @button_time = button_time
    end
    
  end
  
  module BATTLECOMMANDS_CONFIG

    #------------------------------------------------------------------------
    # Input Skills Command related 
    #------------------------------------------------------------------------
    
    # Icons used for the Input Icon  
    INPUT_ICONS = {
      Input::DOWN => 9,
      Input::LEFT => 10,
      Input::RIGHT => 12,
      Input::UP => 11,
      Input::A => 1,
      Input::B => 2,
      Input::C => 3,
      Input::X => 4,
      Input::Y => 5,
      Input::Z => 6,
      Input::L => 7,
      Input::R => 8
    }
    
    # Input Skills Button Inputs Settings
    #   syntax: skill_id => array of inputs
    BC_INPUTSKILLS_COMMANDS = [
      InputSkill_Command.new(33, [Input::LEFT,Input::RIGHT,Input::LEFT], 180),
      InputSkill_Command.new(67, [Input::LEFT,Input::DOWN,Input::RIGHT], 240),
      InputSkill_Command.new(69, [Input::LEFT,Input::UP,Input::RIGHT,Input::DOWN], 360),
      InputSkill_Command.new(98, [Input::LEFT,Input::RIGHT,Input::LEFT], 180),
      InputSkill_Command.new(101, [Input::LEFT,Input::UP,Input::RIGHT,Input::DOWN,
                                   Input::A,Input::B,Input::C,Input::X,Input::Y,
                                   Input::Z,Input::L,Input::R], 720)
    ]
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_INPUTSKILLS = Utilities.generate_battle_command_uid("BC_INPUTSKILLS")
    
    # Battle commands data
    #WeaponFilter.new("throw")
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_INPUTSKILLS, BC_SKILL, UsableItemFilter.new("inputskills")))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_INPUTSKILLS))
    
  end
end

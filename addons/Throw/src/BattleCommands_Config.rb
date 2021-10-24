#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB

  #==============================================================================
  # ** Throw_Command
  #------------------------------------------------------------------------------
  #  Represents a throwable weapon battle command
  #==============================================================================

  class Throw_Command < Battle_Command
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Item ID
    attr_reader :item_id
    
    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get the item object of the item battle command
    #--------------------------------------------------------------------------
    def item()
      return $data_weapons[@item_id]
    end
    
    #--------------------------------------------------------------------------
    # * Get the name of the item battle command
    #--------------------------------------------------------------------------
    def name()
      return $data_weapons[@item_id].name
    end
    
    #--------------------------------------------------------------------------
    # * Get the description of the item battle command
    #--------------------------------------------------------------------------
    def description()
      return $data_weapons[@item_id].description
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     id : id
    #     item_id : Item ID to get name and description of the battle command
    #     type :
    #--------------------------------------------------------------------------
    def initialize(id, item_id)
      super(id, BATTLECOMMANDS_CONFIG::BC_THROW)
      @item_id = item_id
    end
    
  end
    
  module BATTLECOMMANDS_CONFIG
  
    # Icons used for the Elemental Resistance Graph and the Elements icons list
    #0 = None           5 = Bow   (no)    10 = Ice    (105) 15 = Holy     (110) 
    #1 = Melee    (no)  6 = Whip  (no)    11 = Thunder(106) 16 = Darkness (111)
    #2 = Percing  (no)  7 = Mind  (no)    12 = Water  (107)
    #3 = Slashing (no)  8 = Absorb (no)   13 = Earth  (108)  
    #4 = Blow  (no)     9 = Fire   (104)  14 = Wind   (109)   
    ELEMENT_ICONS = [0,0,0,0,0,0,0,0,0,104,105,106,107,108,109,110,111]
    
    # Icons used for the Bonus stat in the Bonus icons list
    #0 = Two Handed (50)             2 = Prevent Critical (52) 
    #1 = Critical Bonus  (119)       3 = Half MP Cost (133) 
    BONUS_ICONS = [50,119,52,133]
    
    #------------------------------------------------------------------------
    # Item/Skill Details Window related
    #------------------------------------------------------------------------
    
    # Number of icons to show at the same time
    SW_LIST_MAX_ICONS = 4
    # Timeout in seconds before switching icons
    SW_LIST_ICONS_TIMEOUT = 1

    # Pattern used to show the value of the Recovery effect
    REC_PATTERN = "%d%%+%d"
    # Sign for plus state set
    STATES_PLUS_SIGN = "+"
    # Sign for minus state set
    STATES_MINUS_SIGN = "-"
    
    #------------------------------------------------------------------------
    # Throw Command related 
    #------------------------------------------------------------------------
    
    # Items ID that can be thrown
    BC_THROW_ITEMS_ID = [1,2,3,6,9,10,12,13,14,16,20,21,23,27,29,30,32,33]
    
    # Throw bonus damage rate (applied to weapon)
    BC_THROW_BONUS_DMG_RATE = 250
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_THROW = Utilities.generate_battle_command_uid("BC_THROW")
    
    # Battle commands data
    #WeaponFilter.new("throw")
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_THROW, BC_THROW))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_THROW))
    
  end
end

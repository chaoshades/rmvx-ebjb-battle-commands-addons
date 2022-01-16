#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  #==============================================================================
  # ** StealItem
  #------------------------------------------------------------------------------
  #  Represents a
  #==============================================================================

  class StealItem
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    attr_accessor :kind
    attr_accessor :item_id
    attr_accessor :denominator

    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Determine if battler is animated
    #--------------------------------------------------------------------------
    def item
      item = nil
      case @kind
      when 0
        item = $data_items[@item_id]
      when 1
        item = $data_weapons[@item_id]
      when 2
        item = $data_armors[@item_id]
      end
      return item
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     kind : Type of the drop item (0: none, 1: item, 2: weapon, 3: armor)
    #     id : item id
    #     denom  : steal rate denominator
    #--------------------------------------------------------------------------
    def initialize(kind, id, denom)
      @kind = kind
      @item_id = id
      @denominator = denom
    end
        
  end

  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Steal Command related 
    #------------------------------------------------------------------------
    
    # True to steal only one item from a monster in combat, else false
    BC_STEAL_ONLY_ONCE = false
    
    # True for agility based steal, else false
    BC_STEAL_AGILITY_BASED = true
    
    # Items ID that be stealed from enemies
    #   syntax: enemy_id => array of StealItem
    BC_STEAL_ENEMY_STEALS_ID = {
      1 => [StealItem.new(0, 1, 2), StealItem.new(1, 1, 2), StealItem.new(2, 1, 2),
            StealItem.new(0, 8, 256)]
    }
    
    # Items ID that add a bonus to Steal
    #   syntax: item_id => rate
    BC_STEAL_WEAPON_BONUS_ID = {
      34 => 50
    }
    # Items ID that add a bonus to Steal
    #   syntax: item_id => rate
    BC_STEAL_ARMOR_BONUS_ID = {
      32 => 10
    }
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_STEAL = Utilities.generate_battle_command_uid("BC_STEAL")
    BC_MUG = Utilities.generate_battle_command_uid("BC_MUG")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_STEAL, BC_STEAL))
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_MUG, BC_MUG))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_STEAL))
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_MUG))
    
  end
end

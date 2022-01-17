################################################################################
#                EBJB Slot Machine Command - EBJB_BCSLOTMACHINE       #   VX   #
#                          Last Update: 2012/10/28                    ##########
#                          Author : ChaosHades                                 #
#     Source :                                                                 #
#     http://www.google.com                                                    #
#------------------------------------------------------------------------------#
#  Description of the script                                                   #
#==============================================================================#
#                         ** Instructions For Usage **                         #
#  There are settings that can be configured in the BattleCommands_Config      #
#  class. For more info on what and how to adjust these settings, see the      #
#  documentation  in the class.                                                #
#==============================================================================#
#                                ** Examples **                                #
#  See the documentation in each classes.                                      #
#==============================================================================#
#                           ** Installation Notes **                           #
#  Copy this script in the Materials section                                   #
#==============================================================================#
#                             ** Compatibility **                              #
#  Works With: Script Names, ...                                               #
#  Alias: Class - method, ...                                                  #
#  Overwrites: Class - method, ...                                             #
################################################################################

$imported = {} if $imported == nil
$imported["EBJB_BCSLOTMACHINE"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Slot Machine Command related 
    #------------------------------------------------------------------------
    
    # Skills ID that are slot machine skills (depends on SSS::SLOT_ICONS)
    BC_SLOT_MACHINE_SKILLS ={
      1 => 111,
      2 => 112,
      3 => 113
    }
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_SLOT_MACHINE = Utilities.generate_battle_command_uid("BC_SLOT_MACHINE")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(Battle_Command.new(BC_SLOT_MACHINE, BC_SLOT_MACHINE))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[1].push(LearningBattleCommand.new(BC_SLOT_MACHINE))
    
  end
end

#==============================================================================
# ** Game_BattleAction
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_BattleAction
  
  #--------------------------------------------------------------------------
  # * Set Slot Machine Attack
  #--------------------------------------------------------------------------
  def set_slot_machine(skill_id)
    @kind = 0
    @basic = 18
    @skill_id = skill_id
  end
  
  #--------------------------------------------------------------------------
  # * Set Failed Slot Machine Attack
  #--------------------------------------------------------------------------
  def set_failed_slot_machine
    @kind = 0
    @basic = 19
  end
  
  #--------------------------------------------------------------------------
  # * Slot Machine Attack Determination
  #--------------------------------------------------------------------------
  def slot_machine?
    return (@kind == 0 and @basic == 18)
  end
  
  #--------------------------------------------------------------------------
  # * Failed Slot Machine Attack Determination
  #--------------------------------------------------------------------------
  def failed_slot_machine?
    return (@kind == 0 and @basic == 19)
  end

  #--------------------------------------------------------------------------
  # * Get Skill Object
  #--------------------------------------------------------------------------
  alias skill_bc_slot_machine skill unless $@
  def skill
    return slot_machine? ? $data_skills[@skill_id] : skill_bc_slot_machine
  end
  
  #--------------------------------------------------------------------------
  # * Alias make_targets
  #--------------------------------------------------------------------------
  alias make_targets_bc_slot_machine make_targets unless $@
  def make_targets
    if slot_machine?
      return make_obj_targets(skill)
    elsif failed_slot_machine?
      return [battler]
    else
      return make_targets_bc_slot_machine
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias determine_action_name
  #--------------------------------------------------------------------------
  alias determine_action_name_bc_slot_machine determine_action_name unless $@
  def determine_action_name()
    action_name = ""
    if self.slot_machine?
      action_name = "Slot Machine"
    else
      action_name = determine_action_name_bc_slot_machine
    end
    
    return action_name
  end
  
  #--------------------------------------------------------------------------
  # * Alias valid?
  #--------------------------------------------------------------------------
  alias valid_bc_slot_machine? valid? unless $@
  def valid?
    return true if slot_machine?
    return true if failed_slot_machine?
    return valid_bc_slot_machine?
  end
  
end
#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#   This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_slot_machine start unless $@
  def start
    start_bc_slot_machine
    
    @slot_machine_inputting = false
  end
  
  #--------------------------------------------------------------------------
  # * Alias custom_actor_command_active?
  #--------------------------------------------------------------------------
  alias custom_actor_command_active_bc_slot_machine? custom_actor_command_active? unless $@
  def custom_actor_command_active?
    if @slot_machine_inputting
      return true
    else 
      return custom_actor_command_active_bc_slot_machine?
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_battle_commands
  #--------------------------------------------------------------------------
  alias execute_battle_commands_bc_slot_machine execute_battle_commands unless $@
  def execute_battle_commands(actor)
    command = @actor_command_window.selected_command
    if command.type == BATTLECOMMANDS_CONFIG::BC_SLOT_MACHINE
      Sound.play_decision
      skill_id = determine_slot_machine_skill(actor)
      if skill_id == nil
        actor.action.set_failed_slot_machine
      else
        actor.action.set_slot_machine(skill_id)
      end
      add_to_battleline(actor)
      end_actor_command_selection()
    else
      execute_battle_commands_bc_slot_machine(actor)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Alias execute_action
  #--------------------------------------------------------------------------
  alias execute_action_bc_slot_machine execute_action unless $@
  def execute_action
    if @active_battler.action.slot_machine?
      execute_action_skill
      @active_battler.action.clear
    elsif @active_battler.action.failed_slot_machine?
      execute_action_failed_slot_machine
      @active_battler.action.clear
    else
      execute_action_bc_slot_machine
    end
  end
  
  #--------------------------------------------------------------------------
  # * Execute Battle Action: Failed Slot Machine
  #--------------------------------------------------------------------------
  def execute_action_failed_slot_machine
    @top_help_window.set_text("Bad luck")
    @top_help_window.visible = true
    @active_battler.stamina_wait = true
    @active_battler.empty_stamina
    execute_basic_action(nil)
    @top_help_window.visible = false
  end
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def start_slot_machine_inputting
    actor = $game_party.members[@actor_index]
    actor.white_flash = true
    @targeting_window.active = false
    @slot_machine_inputting = true
    deactivate_stamina(0)
  end
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def end_slot_machine_inputting
    for actor in $game_party.members
      actor.white_flash = false
    end

    @slot_machine_inputting = false
    activate_stamina(0)
  end
  
  #--------------------------------------------------------------------------
  # * 
  #--------------------------------------------------------------------------
  def determine_slot_machine_skill(battler)
    skill_id = nil
    
    start_slot_machine_inputting
    # Run Slot Machine and get the results
    result = slot_machine(BATTLECOMMANDS_CONFIG::BC_SLOT_MACHINE_SKILLS.size)
    end_slot_machine_inputting

    # Determines the skill ID from the results
    if result != 0
      skill_id = BATTLECOMMANDS_CONFIG::BC_SLOT_MACHINE_SKILLS[result]
    end
    
    return skill_id
  end
  
end

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab
  class << self
  include EBJB
    #//////////////////////////////////////////////////////////////////////////
    # * Public Methods
    #//////////////////////////////////////////////////////////////////////////
    
    #//////////////////////////////////////////////////////////////////////////
    # Battle Commands related
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get Strings to show for every battle command (name + description)
    #--------------------------------------------------------------------------
    alias battle_commands_strings_bc_slot_machine battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_slot_machine.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_SLOT_MACHINE => ["Slot Machine", "Uses a magical slot machine"]
      })
    end
    
  end
end


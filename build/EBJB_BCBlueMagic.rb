################################################################################
#                 EBJB Blue Magic Command - EBJB_BCBLUEMAGIC          #   VX   #
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
$imported["EBJB_BCBLUEMAGIC"] = true

#==============================================================================
# ** BATTLECOMMANDS_CONFIG
#------------------------------------------------------------------------------
#  Contains the BattleCommands_Config configuration
#==============================================================================

module EBJB
  
  module BATTLECOMMANDS_CONFIG
    
    #------------------------------------------------------------------------
    # Blue Magic Command related 
    #------------------------------------------------------------------------
    
    # Unique ids used to represent Blue Magic Learn types
    # BM_TYPE = 10xx
    
    # Learn magic when battler is hit by it
    BM_TYPE_HIT = 1001
    # Learn magic when enemy cast it
    BM_TYPE_CAST = 1002
    # Learn magic when battler analyze the enemy
    BM_TYPE_ANALYZE = 1003
    
    # Array of learning types, combine any type that you want
    BC_BLUE_MAGIC_LEARN_TYPE = [BM_TYPE_HIT, BM_TYPE_CAST, BM_TYPE_ANALYZE]
    
    # Skills ID that are blue magics
    BC_BLUE_MAGIC_SKILLS_ID = (104..105).to_a
    
    #------------------------------------------------------------------------
    # Battle Commands Definitions
    #------------------------------------------------------------------------
    
    # Unique ids used to represent battle commands
    # BATTLE_COMMAND = 10xx
    BC_BLUE_MAGIC = Utilities.generate_battle_command_uid("BC_BLUE_MAGIC")
    BC_ANALYZE = Utilities.generate_battle_command_uid("BC_ANALYZE")
    
    # Battle commands data
    DATA_BATTLE_COMMANDS.push(List_Command.new(BC_BLUE_MAGIC, BC_SKILL, UsableItemFilter.new("bluemagic")))
    DATA_BATTLE_COMMANDS.push(Skill_Command.new(BC_ANALYZE, 91, true))
    
    # Actor Battle Commands Settings
    #   syntax: actor_id => [LearningBattleCommand.new('type', ...), ...]
    #   Where 'type' is one of the Battle commands above
    CLASS_BATTLE_COMMANDS_LEARNINGS[4].push(LearningBattleCommand.new(BC_BLUE_MAGIC))
    CLASS_BATTLE_COMMANDS_LEARNINGS[4].push(LearningBattleCommand.new(BC_ANALYZE))
    
  end
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  include EBJB
  
  #--------------------------------------------------------------------------
  # * Alias skills
  #--------------------------------------------------------------------------
  alias skills_bc_bluemagic skills unless $@
  def skills
    result = skills_bc_bluemagic
    if is_command_equipped?($game_battle_commands[BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC])
      result.concat($game_party.blue_magic_skills)
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Alias skill_learn?
  #--------------------------------------------------------------------------
  alias skill_learn_bc_bluemagic? skill_learn? unless $@
  def skill_learn?(skill)
    return $game_party.blue_magic_learn?(skill) || skill_learn_bc_bluemagic?(skill)
  end
  
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler

  #--------------------------------------------------------------------------
  # * Alias skill_effect
  #--------------------------------------------------------------------------
  alias skill_effect_bc_bluemagic skill_effect unless $@
  def skill_effect(user, skill)
    if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_SKILLS_ID.include?(skill.id)
      if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_LEARN_TYPE.include?(BATTLECOMMANDS_CONFIG::BM_TYPE_CAST)
        $game_party.learn_blue_magic(skill.id)
      end
      
      if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_LEARN_TYPE.include?(BATTLECOMMANDS_CONFIG::BM_TYPE_HIT)
        if self.actor? && !user.actor?
          $game_party.learn_blue_magic(skill.id)
        end     
      end
      
      if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_LEARN_TYPE.include?(BATTLECOMMANDS_CONFIG::BM_TYPE_ANALYZE)
        if !self.actor? && user.actor?
          enemy_skills = self.enemy.actions.collect{|x| $data_skills[x.skill_id] if x.skill?}
          enemy_skills.compact!
          for s in enemy_skills
            if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_SKILLS_ID.include?(s.id)
              $game_party.learn_blue_magic(s.id)
            end
          end
        end     
      end
    end
    
    skill_effect_bc_bluemagic(user, skill)
  end
  
end

#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
# and items. The instance of this class is referenced by $game_party.
#==============================================================================

class Game_Party < Game_Unit
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  alias initialize_bc_bluemagic initialize unless $@
  def initialize
    initialize_bc_bluemagic
    @blue_magic_skills = []
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Blue Magic Skill Object Array
  #--------------------------------------------------------------------------
  def blue_magic_skills
    result = []
    for i in @blue_magic_skills
      result.push($data_skills[i])
    end
    return result
  end
  
  #--------------------------------------------------------------------------
  # * Learn Blue Magic Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def learn_blue_magic(skill_id)
    unless blue_magic_learn?($data_skills[skill_id])
      @blue_magic_skills.push(skill_id)
      @blue_magic_skills.sort!
    end
  end
  
  #--------------------------------------------------------------------------
  # * Forget Blue Magic Skill
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def forget_blue_magic(skill_id)
    @blue_magic_skills.delete(skill_id)
  end
  
  #--------------------------------------------------------------------------
  # * Determine if Finished Learning Blue Magic Skill
  #     skill : skill
  #--------------------------------------------------------------------------
  def blue_magic_learn?(skill)
    return @blue_magic_skills.include?(skill.id)
  end
  
end

#==============================================================================
# ** UsableItemFilter
#------------------------------------------------------------------------------
#  Represents a UsableItem filter
#==============================================================================

class UsableItemFilter < Filter
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias apply
  #--------------------------------------------------------------------------
  alias apply_bc_blue_magic apply unless $@
  def apply(x)
    if x != nil && x.is_a?(RPG::UsableItem)
       
      case mode
        when "bluemagic"
          return applyBlueMagic(x)
        #when
          #...
        else
          return apply_bc_blue_magic(x)
      end
      
    else
      return nil
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Apply method (using the id property)
  #     x : object to filter
  #--------------------------------------------------------------------------
  def applyBlueMagic(x)
    if BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC_SKILLS_ID.include?(x.id)
      return true
    else
      return false
    end
  end
  private:applyBlueMagic
  
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
    alias battle_commands_strings_bc_blue_magic battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_blue_magic.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_BLUE_MAGIC => ["Blue Magic", "Uses a monster spell"]
      })
    end
    
  end
end


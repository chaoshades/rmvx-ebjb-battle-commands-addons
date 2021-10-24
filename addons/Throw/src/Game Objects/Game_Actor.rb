#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias setup_bc_throw setup unless $@
  def setup(actor_id)
    setup_bc_throw(actor_id)
    actor = $data_actors[actor_id]

    @battle_animation.ani_throw_weapons = actor.ani_throw_weapons
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias is_command_equipped?
  #--------------------------------------------------------------------------
  alias is_command_equipped_bc_throw? is_command_equipped? unless $@
  def is_command_equipped?(obj)
    if (obj.is_a?(RPG::Weapon))
      return active_battle_commands.any?{|c| c.is_a?(Throw_Command) && c.item_id == obj.id} || 
             is_command_equipped_bc_throw?(obj)
    elsif (obj.is_a?(Throw_Command))
      return active_battle_commands.any?{|c| c.id == obj.id} 
    else
      return is_command_equipped_bc_throw?(obj)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Create Battle Action (for automatic battle)
  #--------------------------------------------------------------------------
  def make_autobattle_action
    @action.clear
    return unless movable?
    action = Game_BattleAction.new(self)
    
    command = self.autobattle_command
    if command.is_a?(Skill_Command)
      if command.is_custom
        action.forcing = true
      end
      if self.skill_can_use?(command.skill) || command.is_custom
        action.set_skill(command.skill.id)
      end
    elsif command.is_a?(Item_Command)
      if $game_party.item_can_use?(command.item)
        action.set_item(command.item.id)
      end
    elsif command.is_a?(Throw_Command)
      if $game_party.item_can_throw?(command.item)
        action.set_throw(command.item.id)
      end
    else
      case command.type
      when BATTLECOMMANDS_CONFIG::BC_ATTACK 
        action.set_attack
      when BATTLECOMMANDS_CONFIG::BC_GUARD
        action.set_guard
      end
    end
    
    action.evaluate
    
    #Keeps action if it has been evaluated, else don't do anything
    if action.value > 0
      @action = action
    end
  end
  
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias is_command_equipped?
  #--------------------------------------------------------------------------
  alias is_command_equipped_bc_morph? is_command_equipped? unless $@
  def is_command_equipped?(obj)
    if (obj.is_a?(RPG::Skill))
      return active_battle_commands.any?{|c| c.is_a?(Morph_Command) && c.skill_id == obj.id} || 
             is_command_equipped_bc_morph?(obj)
    elsif (obj.is_a?(Morph_Command))
      return active_battle_commands.any?{|c| c.id == obj.id} 
    else
      return is_command_equipped_bc_morph?(obj)
    end
  end
  
end

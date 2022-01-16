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

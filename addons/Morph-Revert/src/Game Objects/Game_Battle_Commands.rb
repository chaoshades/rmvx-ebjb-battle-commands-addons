#==============================================================================
# ** Game_Battle_Commands
#------------------------------------------------------------------------------
#  This class handles the battle commands array. The instance of this class is
# referenced by $game_battle_commands.
#==============================================================================

class Game_Battle_Commands
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Add existing command
  #     command : command object
  #--------------------------------------------------------------------------
  def add_morph_command(command)
    id = command.id
    if (!@data.include?(id))
      @data[id] = command
    end
    return @data[id]
  end
  
end

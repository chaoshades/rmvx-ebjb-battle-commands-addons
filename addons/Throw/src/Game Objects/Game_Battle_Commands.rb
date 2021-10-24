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
  # * Add new Item command
  #     item : item object
  #--------------------------------------------------------------------------
  def add_throw_command(item)
    id = Utilities.generate_battle_command_uid("BC_THROW_"+item.id.to_s)
    if (!@data.include?(id))
      @data[id] = Throw_Command.new(id, item.id)
    end
    return @data[id]
  end
  
end

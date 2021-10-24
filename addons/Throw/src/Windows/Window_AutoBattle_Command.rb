#===============================================================================
# ** Window_AutoBattle_Command
#------------------------------------------------------------------------------
#  This window displays 
#===============================================================================

class Window_AutoBattle_Command < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias create_item
  #--------------------------------------------------------------------------
  alias create_item_bc_throw create_item unless $@
  def create_item(command, actor, rect)   
    if command.is_a?(Throw_Command)
      return UCItem.new(self, command.item, rect)
    else
      return create_item_bc_throw(command, actor, rect)
    end
  end
  private :create_item
  
end

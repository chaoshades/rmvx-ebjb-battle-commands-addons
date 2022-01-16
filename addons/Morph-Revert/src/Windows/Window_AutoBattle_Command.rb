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
  alias create_item_bc_morph create_item unless $@
  def create_item(command, actor, rect)
    if command.is_a?(Morph_Command)
      return UCSkill.new(self, command.skill, rect, actor.calc_mp_cost(command.skill))
    else
      return create_item_bc_morph(command, actor, rect)
    end
  end
  private :create_item
  
end

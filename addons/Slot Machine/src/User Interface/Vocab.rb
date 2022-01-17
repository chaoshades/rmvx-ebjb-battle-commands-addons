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

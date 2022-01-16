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
    alias battle_commands_strings_bc_multi_attack battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_multi_attack.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_MULTI_ATTACK => ["Multi Attack", "Attacks multiple enemies at the same time"]
      })
    end
    
  end
end

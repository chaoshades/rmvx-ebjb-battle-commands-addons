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
    alias battle_commands_strings_bc_summon_magic battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_summon_magic.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_SUMMON_MAGIC => ["Summon", "Calls a summoned monster"]
      })
    end
    
  end
end

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
    alias battle_commands_strings_bc_steal battle_commands_strings unless $@
    def battle_commands_strings
      return battle_commands_strings_bc_steal.merge(
      {
       BATTLECOMMANDS_CONFIG::BC_STEAL => ["Steal", "Steals from a target"],
       BATTLECOMMANDS_CONFIG::BC_MUG => ["Mug", "Steals from a target and attacks if afterwards"]
      })
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show in battle help when there is nothing to steal
  #--------------------------------------------------------------------------
  def self.no_steal_text
    return "Nothing to steal"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show in battle help when failing to steal
  #--------------------------------------------------------------------------
  def self.failed_steal_text
    return "Couldn't steal anything"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show in battle help when stealing successfully
  #--------------------------------------------------------------------------
  def self.success_steal_text
    return "You stole %s"
  end
end

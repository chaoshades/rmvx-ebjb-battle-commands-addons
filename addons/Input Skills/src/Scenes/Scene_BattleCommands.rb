#==============================================================================
# ** Scene_BattleCommands
#------------------------------------------------------------------------------
#  This class performs the battle commands change screen processing.
#===============================================================================

class Scene_BattleCommands < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias start
  #--------------------------------------------------------------------------
  alias start_bc_inputskills start unless $@
  def start
    start_bc_inputskills()
    
    @input = false
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias update_battle_command_selection
  #--------------------------------------------------------------------------
  alias update_battle_command_selection_bc_inputskills update_battle_command_selection unless $@
  def update_battle_command_selection()
    update_battle_command_selection_bc_inputskills()
    
    if Input.trigger?(Input::RIGHT)
      if @battle_commands_window.selected_battle_command.is_a?(List_Command)
        if @battle_commands_window.selected_battle_command.type == BATTLECOMMANDS_CONFIG::BC_INPUTSKILLS 
          @input = true
        end
      end
    end    
  end
  private :update_battle_command_selection

  #--------------------------------------------------------------------------
  # * Update Skill Command Selection
  #--------------------------------------------------------------------------
  alias update_skill_command_selection_bc_inputskills update_skill_command_selection unless $@
  def update_skill_command_selection()
    if Input.trigger?(Input::C) && @input == true
      # Blocks input skill has an auto battle command because it would break
      # gameplay by switching inputs between the autobattle actor and the current actor
      if @skill_command_window.selected_skill == nil ||
         @autobattle_window.active ||
         (!@autobattle_window.active && !@skill_command_window.enable?(@skill_command_window.selected_skill))
        Sound.play_buzzer
      else
        Sound.play_decision
        command = BATTLECOMMANDS_CONFIG::BC_INPUTSKILLS_COMMANDS.select{|x| x.skill_id == @skill_command_window.selected_skill.id}.first
        $game_battle_commands.add_inputskills_command(command)
        change_battle_command(command)
      end
    else
      update_skill_command_selection_bc_inputskills()
    end
  end

end

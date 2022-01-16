#==============================================================================
# ** Window_InputSkill
#------------------------------------------------------------------------------
#  This window shows the details of a skill
#==============================================================================

class Window_InputSkill < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCBar for the time left for the input
  attr_reader :ucBarTimeLeft
  # Icon for the next input of the skill
  attr_reader :ucInput
  # Input Skill Command object of the skill
  attr_accessor :input_command

  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     input_command : Input Skill Command object
  #     spacing : spacing between stats
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, input_command, spacing = 10)
    super(x, y, width, height)
    
    @ucInput = UCInputIcon.new(self, Rect.new(0,0,24,24), 0)
    @ucInput.active = active
    @ucInput.visible = visible
    
    @ucBarTimeLeft = UCBar.new(self, Rect.new(48,4,100,WLH-8), 
                              Color.input_time_gauge_color1, Color.input_time_gauge_color2, Color.gauge_back_color, 
                              0, 0, 4, Color.gauge_back_color)
    @ucBarTimeLeft.active = active
    @ucBarTimeLeft.visible = visible
    
    window_update(input_command)
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     members : party members
  #--------------------------------------------------------------------------
  def window_update(input_command)
    if input_command != nil
      @input_command = input_command
      @ucInput.iconIndex = BATTLECOMMANDS_CONFIG::INPUT_ICONS[input_command.button_inputs[0]]
      @ucBarTimeLeft.value = 0
      @ucBarTimeLeft.max_value = input_command.button_time
    end
    refresh()
  end

  #--------------------------------------------------------------------------
  # * Update
  #     members : party members
  #--------------------------------------------------------------------------
  def update_values(button_index, button_time)
    if button_index != nil && button_time != nil
      @ucInput.iconIndex = BATTLECOMMANDS_CONFIG::INPUT_ICONS[input_command.button_inputs[button_index]]
      @ucBarTimeLeft.value = button_time
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucInput.draw()
    @ucBarTimeLeft.draw()
  end
  
end

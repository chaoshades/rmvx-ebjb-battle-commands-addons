#==============================================================================
# ** Window_Throw_Command
#------------------------------------------------------------------------------
#  This window displays a list of throwable items for the item screen, etc.
#==============================================================================

class Window_Throw_Command < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCItem for every item in the inventory
  attr_reader :ucItemsList

  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current item
  #--------------------------------------------------------------------------
  # GET
  def selected_item
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #     items : items list
  #     filter : filter object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor=nil, items=nil, filter=nil)
    super(x, y, width, height)
    @column_max = 2
    @ucItemsList = []
    window_update(actor, items, filter)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #     items : items list
  #     filter : filter object
  #--------------------------------------------------------------------------
  def window_update(actor, items, filter)
    @data = []
    if actor != nil && items != nil 
      @actor = actor

      if filter != nil
        temp_items = items.find_all{|x| filter.apply(x)}
      else
        temp_items = items
      end

      for item in temp_items
        if item != nil && (filter != nil || include?(item))
          @data.push(item)
        end
      end
      @item_max = @data.size
      create_contents()
      @ucItemsList.clear()
      for i in 0..@item_max-1
        @ucItemsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucItemsList.each() { |ucItem| ucItem.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
#~     if @help_window.is_a?(Window_Help)
#~       @help_window.set_text(item == nil ? "" : item.description)
#~     else
      if selected_item != nil
        @help_window.window_update(selected_item.description)
      else
        @help_window.window_update("")
      end
#~     end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_item != nil
      @detail_window.window_update(selected_item)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_item != nil && selected_item.is_a?(RPG::Weapon)
  end
  
  #--------------------------------------------------------------------------
  # * Whether or not to display in enabled state
  #     item : item object
  #--------------------------------------------------------------------------
  def enable?(item)
    return !@actor.is_command_equipped?(item)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Whether or not to include in item list
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    return item.is_a?(RPG::Weapon) && BATTLECOMMANDS_CONFIG::BC_THROW_ITEMS_ID.include?(item.id)
  end
  private :include?
  
  #--------------------------------------------------------------------------
  # * Create an item for SkillsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index, true)
    
    ucItem = UCItem.new(self, item, rect)
    ucItem.active = enable?(item)
                              
    return ucItem
  end
  private :create_item
  
end

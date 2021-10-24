#==============================================================================
# ** Window_BattleThrow
#------------------------------------------------------------------------------
#  This window displays a list of usable throwable weapons during battle.
#==============================================================================

class Window_BattleThrow < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of CLabel for every throwable weapons
  attr_reader :cWeaponsList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current weapon
  #--------------------------------------------------------------------------
  # GET
  def selected_weapon
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
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, items)
    super(x, y, width, height)
    @column_max = 1
    @cWeaponsList = []
    window_update(items)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     items : items list
  #--------------------------------------------------------------------------
  def window_update(items)
    @data = []
    if items != nil
      for item in items
        next unless include?(item)
        if item != nil
          @data.push(item)
        end
      end
      @item_max = @data.size
      create_contents()
      @cWeaponsList.clear()
      for i in 0..@item_max-1
        @cWeaponsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cWeaponsList.each() { |cWeapon| cWeapon.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if @help_window.is_a?(Window_Help)
      @help_window.set_text(selected_weapon == nil ? "" : selected_weapon.description)
#~     else
#~       if selected_weapon != nil
#~         @help_window.window_update(selected_weapon.description)
#~       else
#~         @help_window.window_update("")
#~       end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_weapon != nil
      @detail_window.window_update(selected_weapon)
    else
      @detail_window.window_update(nil)
    end
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
  # * Create an item for WeaponsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    weapon = @data[index]
    rect = item_rect(index, true)
    
    cWeapon = UCItem.new(self, weapon, rect)
  
    return cWeapon
  end
  private :create_item
  
end

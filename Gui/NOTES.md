# VBoxContainer /HBoxContainer
* seem pretty typical. like any other GUI kit


# MenuBar
* Use`MenuBar` for top row menu
* couldn't figure out how to float two items on left and a third on the right. 
  * went with a `HBoxContainer` and *two* `MenuBar` nodes

* docs says that `MenuBar` "creates a menu for each PopupMenu child. New items are created by adding PopupMenus to this node"
  * added menu items in GUI using `Inspector | PopupMenu > Items`
    You can set mutiple options such as Text, Icon, Checkable/Checked, ID, etc
* You respond to menu items through Signals (unsurprisingly). 
  Select the `PopupMenu` and check `Node | Signas > PopuMenu`.  `id_pressed( id: int )` will
  give you the ID of the menu item that was pressed

* you can programatically add itme to a menu
```gd
func _setup_menu_1() -> void:
    var count = menu_bar_1.get_menu_count()
    print( "MenuBar 1 menu count: " + str( count ))
    var file_popup = menu_bar_1.get_menu_popup(0)
    file_popup.add_item("Dynamic Item ID: " + str(count), count)
    count += 1
    file_popup.add_item("Dynamic Item ID: "+ str(count), count)
```
# 

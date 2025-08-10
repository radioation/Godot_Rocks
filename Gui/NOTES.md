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

* you can programatically add items to a menu
```gd

@onready var menu_bar_1 : MenuBar = $VBoxContainer/HBoxContainer/MenuBar

...


func _setup_menu_1() -> void:
    var count = menu_bar_1.get_menu_count()
    print( "MenuBar 1 menu count: " + str( count ))
    var file_popup = menu_bar_1.get_menu_popup(0)
    file_popup.add_item("Dynamic Item ID: " + str(count), count)
    count += 1
    file_popup.add_item("Dynamic Item ID: "+ str(count), count)
```

* and handle checkboxes 
```gd
func _on_view_popupmenu_id_pressed(id: int) -> void:
    print(" VIEW MENU ID: %d " % id ) 
    var view_popup :PopupMenu = menu_bar_1.get_menu_popup(1)
    var checked: bool = view_popup.is_item_checked( id )
    
    print( "ID: %d is checked: %s " % [id, checked ]) 
    view_popup.set_item_checked( id, !checked )
```
## Aboot dialog
* make a Scene from a `Window` and add UI elements as needed for the dialog box
* can load it from the menu item signal
```gd
func _on_help_popupmenu_id_pressed(id: int) -> void:
    print(" HELP MENU ID: %d " % id ) 
    if id == 0:
        if about_dialog == null:
            about_dialog = about_scene.instantiate()
            add_child( about_dialog)
        #about_dialog.show()
        about_dialog.popup_centered()
```


# 

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

## FileDialog 
not much to it, add it as a node in your scene and load it with `@onready`
```gd
@onready var file_dialog: FileDialog = $FileDialog
```
can be configured
```gd
    #file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILES
    file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
    file_dialog.access = FileDialog.ACCESS_FILESYSTEM
    #file_dialog.filters = PackedStringArray(["*.png;*.jpg;*.jpeg;*.bmp;*.tga;*.webp;*.exr;*.hdr;*.glb;*.gltf;*.obj;*.dae;*.mesh ; Images & 3D"])
    file_dialog.files_selected.connect(_on_files_chosen)
```
and easy to show

```gd
        file_dialog.popup_centered()
```
handle the node signal to get the selection.
```gd

func _on_file_dialog_dir_selected(dir: String) -> void:
    print("DIR: %s" % dir)
```
# Tree
pretty trivial to fill up
```gd
    files_tree.clear()
    var root = files_tree.create_item()   # NULL will be root
    root.set_text(0,"ROOT")


    var child1 = files_tree.create_item(root)   # child of root
    child1.set_text(0, "child1")
    var child2 = files_tree.create_item(root)   # child of root
    child2.set_text(0, "child2")
    
     
    var child1_1 = files_tree.create_item( child1)  # Children having children
    child1_1.set_text(0,"child_1_1")   
```


filesystem example using Metadata to store full paths
```gd
func get_directory_list( path: String, tree_item: TreeItem ) -> void:
    var dir = DirAccess.open(path)
    
    if dir:
        dir.list_dir_begin()
        var file_name = dir.get_next()
        while file_name != "":
            var new_tree_item = files_tree.create_item(tree_item)

            
            new_tree_item.set_text(0, file_name )   # DISPLAYS JUST THE LEAF
            new_tree_item.set_metadata(0, path.path_join(file_name))  # STORES TEH WHOLE PATH


            if dir.current_is_dir():
                print("DIR: " + path.path_join(file_name))
                get_directory_list(path.path_join(file_name), new_tree_item)
            else:
                print("file: " + file_name)
            file_name = dir.get_next()
        dir.list_dir_end()
```
and access with the `_item_selected()` signal
```gd
func _on_files_tab_tree_item_selected() -> void:
    var tree_item = files_tree.get_selected()
    print( "SELECTED: %s - %s" % [ tree_item.get_text(0), tree_item.get_metadata(0) ] )
```




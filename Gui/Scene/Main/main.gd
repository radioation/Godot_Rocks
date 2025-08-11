extends Control

@export var about_scene : PackedScene
var about_dialog: Window

@onready var menu_bar_1 : MenuBar = $VBoxContainer/HBoxContainer/MenuBar
@onready var menu_bar_2 : MenuBar = $VBoxContainer/HBoxContainer/MenuBar2


@onready var file_dialog: FileDialog = $FileDialog

@onready var files_tree: Tree = $VBoxContainer/HSplitContainer/LeftVBoxContainer/TabContainer/FilesTabTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_menu_1()
	_setup_menu_2()
	
	files_tree.clear()
	var root = files_tree.create_item()
	root.set_text(0,"ROOT")
	var child1 = files_tree.create_item(root)
	child1.set_text(0, "child1")
	var child2 = files_tree.create_item(root)
	child2.set_text(0, "child2")
	
	
	var child1_1 = files_tree.create_item( child1)
	child1_1.set_text(0,"child_1_1")
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _setup_menu_1() -> void:
	var count = menu_bar_1.get_menu_count()
	print( "MenuBar 1 menu count: " + str( count ))
	var file_popup = menu_bar_1.get_menu_popup(0)
	file_popup.add_item("Dynamic Item ID: " + str(count), count)
	count += 1
	file_popup.add_item("Dynamic Item ID: "+ str(count), count)
	
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.dir_selected.connect(_on_file_dialog_dir_selected)


func _setup_menu_2() -> void:
	var view_popup = menu_bar_1.get_menu_popup(1)
	view_popup.id_pressed.connect(_on_view_popupmenu_id_pressed)

func _on_file_popup_menu_id_pressed(id: int) -> void:
	print(" FILE MENU ID: %d " % id ) 
	if id == 0 :
		file_dialog.popup_centered()

 
func _on_help_popupmenu_id_pressed(id: int) -> void:
	print(" HELP MENU ID: %d " % id ) 
	if id == 0:
		if about_dialog == null:
			about_dialog = about_scene.instantiate()
			add_child( about_dialog)
		#about_dialog.show()
		about_dialog.popup_centered()
	


func _on_view_popupmenu_id_pressed(id: int) -> void:
	print(" VIEW MENU ID: %d " % id ) 
	var view_popup :PopupMenu = menu_bar_1.get_menu_popup(1)
	var checked: bool = view_popup.is_item_checked( id )
	
	print( "ID: %d is checked: %s " % [id, checked ]) 
	view_popup.set_item_checked( id, !checked )
		

	


func _on_file_dialog_dir_selected(path: String) -> void:
	print("DIR: %s" % path)
	files_tree.clear()
	var tree_item = files_tree.create_item()
	tree_item.set_text(0, path)
	get_directory_list(path, tree_item)
 
	

func get_directory_list( path: String, tree_item: TreeItem ) -> void:
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var new_tree_item = files_tree.create_item(tree_item)
			new_tree_item.set_text(0, file_name )
			new_tree_item.set_metadata(0, path.path_join(file_name))
			if dir.current_is_dir():
				print("DIR: " + path.path_join(file_name))
				get_directory_list(path.path_join(file_name), new_tree_item)
			else:
				print("file: " + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()


 


func _on_files_tab_tree_item_selected() -> void:
	var tree_item = files_tree.get_selected()
	print( "SELECTED: %s - %s" % [ tree_item.get_text(0), tree_item.get_metadata(0) ] )

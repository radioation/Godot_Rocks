extends Control

@export var about_scene : PackedScene
var about_dialog: Window

@onready var menu_bar_1 : MenuBar = $VBoxContainer/HBoxContainer/MenuBar
@onready var menu_bar_2 : MenuBar = $VBoxContainer/HBoxContainer/MenuBar2


@onready var file_dialog: FileDialog = $FileDialog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_menu_1()
	_setup_menu_2()
	
	



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
		

	


func _on_file_dialog_dir_selected(dir: String) -> void:
	print("DIR: %s" % dir)
	pass # Replace with function body.

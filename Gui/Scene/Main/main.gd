extends Control

@onready var menu_bar_1 : MenuBar = $VBoxContainer/HBoxContainer/MenuBar
@onready var menu_bar_2 : MenuBar = $VBoxContainer/HBoxContainer/MenuBar2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_menu_1()
	
	



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


func _on_file_popup_menu_id_pressed(id: int) -> void:
	print(" FILE MENU ID: " + str(id))


func _on_help_popmenu_id_pressed(id: int) -> void:
	print(" HELP MENU ID: " + str(id))


func _on_help_popupmenu_id_pressed(id: int) -> void:
	pass # Replace with function body.

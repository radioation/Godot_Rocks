extends Window

@onready var licenses_list: ItemList = $MarginContainer/VBoxContainer/LicensesList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_license_list()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_license_list() -> void: 
	licenses_list.add_item("GUI - MIT License")
	licenses_list.add_item("Godot Engine - MIT License")
	licenses_list.add_item("OpenCV - Apache 2.0")


func _on_button_pressed() -> void:
	hide()


func _on_link_button_pressed() -> void:
	OS.shell_open($MarginContainer/VBoxContainer/HBoxContainer/LinkButton.uri)

tool extends HBoxContainer

onready var file_dialog := $FileDialog
onready var database_file := $Database_file

signal database_create(filename)

func _ready():
	file_dialog.add_filter("*.db ; SQLite Database")

func _on_Open_pressed():
	file_dialog.mode=  FileDialog.MODE_OPEN_FILE
	file_dialog.popup()
	file_dialog.set_position(OS.get_window_size()/2 - file_dialog.get_size()/2)
	#file_dialog.visible = true

func _on_New_pressed():
	file_dialog.mode=  FileDialog.MODE_SAVE_FILE
	file_dialog.visible = true

func _on_FileDialog_file_selected(path):
	database_file.text=path
	emit_signal("database_create", path)

tool extends Control

onready var file_component := $Main/File
onready var list_component := $Main/Base/HSplitContainer/DatabaseList
onready var structure_component := $Main/Base/HSplitContainer/Operations/TabContainer/Structure
onready var data_component := $Main/Base/HSplitContainer/Operations/TabContainer/Data

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

var db

signal list_refresh()
signal structure_info()
signal data_list()

func _ready():
	db = SQLite.new()
	file_component.connect("database_create", self, "_on_database_create")
	list_component.connect("get_database_list", self, "_on_get_database_list")
	list_component.connect("create_table", self, "_on_create_table")
	list_component.connect("selected_table", self, "_on_selected_table")
	connect("list_refresh", list_component, "_on_list_refresh")
	connect("structure_info", structure_component, "_on_structure_info")
	connect("data_list", data_component, "_on_data_list")

func _on_database_create(file):
	db.path = file
	db.verbose_mode = true
	
	db.open_db()
	#after opening, get database list
	_on_get_database_list()
	
	#db.close_db()

func _on_get_database_list():
	# get tables list
	db.query("SELECT name FROM sqlite_master WHERE type ='table' AND name NOT LIKE 'sqlite_%';")
	emit_signal("list_refresh",db.query_result)
	

func _on_create_table(table_name):
	#create table with empty structure
	var structure : Dictionary = Dictionary()
	structure["id"] = {"data_type":"int", "primary_key": true, "not_null": true}
	
	db.create_table(table_name, structure)

func _on_selected_table(table_name):
#    get the table info
	db.query("PRAGMA table_info("+ table_name + ");")
	emit_signal("structure_info",db.query_result)
	#get data from table with pagination
	emit_signal("data_list",db.query_result)



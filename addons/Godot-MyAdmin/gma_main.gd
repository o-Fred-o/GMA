tool extends Control

onready var file_component := $Main/File
onready var list_component := $Main/Base/HSplitContainer/DatabaseList

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

var db

signal list_refresh()

func _ready():
    db = SQLite.new()
    file_component.connect("database_create", self, "_on_database_create")
    list_component.connect("get_database_list", self, "_on_get_database_list")
    list_component.connect("create_table", self, "_on_create_table")
    connect("list_refresh", list_component, "_on_list_refresh")

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

#    get the table info
#    db.query("PRAGMA table_info("+ user_table + ");")
#    print(db.query_result)


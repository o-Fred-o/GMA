tool extends Control

onready var file_component := $Main/File
onready var tablelist_component := $Main/Base/HSplitContainer/TableList
onready var structure_component := $Main/Base/HSplitContainer/Operations/TabContainer/Structure
onready var data_component := $Main/Base/HSplitContainer/Operations/TabContainer/Data

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

#here we only create database connexion and pass the db param to component
#request are made in components

var db

signal open_database()
signal selected_table()

func _ready():
    db = SQLite.new()
    
    file_component.connect("database_selected", self, "_on_database_selected")
    
    connect("open_database", tablelist_component, "_on_open_database")
    tablelist_component.connect("selected_table", structure_component, "_on_selected_table")
    structure_component.connect("data_list", data_component, "_on_data_list")

func _on_database_selected(file):
    db.path = file
    db.verbose_mode = true
    
    db.open_db()
    emit_signal("open_database",db)
    
    
    #db.close_db()

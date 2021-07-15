tool extends Tabs

onready var fields := $Fields/FieldProp

var fieldProp = preload("res://addons/Godot-MyAdmin/component/Structure/FieldProp.tscn")

var data_db
var data_tablename

enum types  { TEXT ,  INTEGER , BLOB }

signal data_list()
signal sql_param()

###################
# Internal signals
###################

func _on_Add_pressed():
    var myFieldProp=fieldProp.instance()
    fields.add_child(myFieldProp)

# todo remove column
# https://www.sqlitetutorial.net/sqlite-alter-table/

func _on_ApplyToDb_pressed():
    var SQL_Query
    for child in fields.get_children():
        #todo build the query
        #ALTER TABLE equipment ADD COLUMN location text;
        var type_node = child.get_node("Type")
        var selected_type = type_node.get_selected_id()
        SQL_Query = "ALTER TABLE "+ data_tablename + " ADD COLUMN "  + child.get_node("Name").text +" " + type_node.get_item_text(selected_type) +";"
    data_db.query(SQL_Query)

###################
# External signals
###################

func _on_selected_table(db,table_name):
    data_db=db
    data_tablename=table_name
    #get the table info
    data_db.query("PRAGMA table_info("+ data_tablename + ");")
    _structure_info(data_db.query_result)
    #get data from table with pagination
    emit_signal("data_list",data_db,data_tablename)
    emit_signal("sql_param",data_db,data_tablename)

###################
# Functions
###################

func _structure_info(info):
    #clear all fieldProp children
    for child in fields.get_children():
        child.queue_free()

    #for each info
    for field in info:
        var myFieldProp=fieldProp.instance()
        myFieldProp.get_node("Name").text=field["name"]
        myFieldProp.get_node("Type").select(types.get(field["type"]))
        myFieldProp.get_node("NotNull").toggle_mode= bool(field["notnull"])
        myFieldProp.get_node("PrimaryKey").toggle_mode= bool(field["pk"])
        if field["dflt_value"]!= null :
            myFieldProp.get_node("Default").text=field["dflt_value"]
        fields.add_child(myFieldProp)
    

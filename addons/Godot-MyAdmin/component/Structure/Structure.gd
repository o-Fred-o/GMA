tool extends Tabs

onready var fields := $Fields/FieldProp
#onready var fieldProp := $TabContainer/Structure/Fields/FieldProp

var fieldProp = preload("res://addons/Godot-MyAdmin/component/Structure/FieldProp.tscn")

enum types  { TEXT ,  INTEGER , BLOB }

func _ready():
	pass # Replace with function body.

func _on_structure_info(info):
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
	
	#[{cid:0, dflt_value:Null, name:id, notnull:1, pk:1, type:INTEGER}, {cid:1, dflt_value:Null, name:nom, notnull:0, pk:0, type:TEXT}, {cid:2, dflt_value:Null, name:prenom, notnull:0, pk:0, type:TEXT}]

func _on_Add_pressed():
	var myFieldProp=fieldProp.instance()
	fields.add_child(myFieldProp)


func _on_ApplyToDb_pressed():
	var SQL_Query
	for child in fields.get_children():
		#todo build the query
		SQL_Query = SQL_Query + "Insert : " + child.get_node("Name").text
		
	print(SQL_Query)

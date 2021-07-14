tool extends Tabs

onready var query := $VBoxContainer/HBoxContainer2/Query
onready var result := $VBoxContainer/HBoxContainer4/Result

var data_db
var data_tablename


###################
# Internal signals
###################

func _on_Execute_pressed():
	data_db.query(query.text)
	result.text = String(data_db.query_result)
	#todo show result as array like in data

###################
# External signals
###################

func _on_sql_param(db,table_name):
	data_db=db
	data_tablename=table_name


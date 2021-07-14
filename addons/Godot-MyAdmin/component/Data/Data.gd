tool extends Tabs

onready var container := $VBoxContainer/ScrollContainer
onready var table := $VBoxContainer/ScrollContainer/Table
onready var nbRecords := $VBoxContainer/Pagination/HBoxContainer/NbRecords

# todo export vars ???
var data_db
var data_tablename

var cellNames = []
var current_id
	

###################
# Internal signals
###################

func _on_Refresh_pressed():
	_refresh_table()

func _on_AddLine_pressed():
	var data= {}
	
	#todo id ??? get index name - use _rowid_
	#get last id
	data_db.query("SELECT MAX(CAST(\"id\" AS INTEGER)) FROM "+data_tablename)
	var maxid = data_db.query_result[0].values()[0]
	if maxid == null:
		maxid = 1 
	else :
		maxid+=1
	
	for cellName in cellNames:
		data[cellName]=null
	data["id"] = maxid
	_add_line(data)
	
	# insert request    
	var query_keys = JSON.print(data.keys()).trim_prefix("[").trim_suffix("]")
	var query_values = JSON.print(data.values()).trim_prefix("[").trim_suffix("]")
	data_db.query("INSERT INTO "+data_tablename+"("+query_keys+") VALUES ("+query_values+");")
	
func _on_Delete_pressed():
	data_db.query("DELETE FROM "+data_tablename+" WHERE id IN ('"+current_id+"')")
	_refresh_table()

#add signal on cell data edit to update the record
func _on_cell_modified(cell):
	#print(cell.text)
	#var line=cell.get_parent()
#    for line_element in line.get_children():
#        print(line_element.text)
	#get the modified id
	#current_id=line.get_children()[0].text
	print(current_id)
	
#todo add signal to change color when cell in select and modif not applied

func _on_cell_selected(cell):
	var line=cell.get_parent()
	#get the selected id
	current_id=line.get_children()[0].text

###################
# External signals
###################

func _on_data_list(db,table_name):
	#update node vars
	data_db=db
	data_tablename=table_name
	
	_refresh_table()
	
###################
# Functions
###################

func _add_line(data):
	var myLine=HBoxContainer.new()
	var cellData
	
	# add a new line
	for cellName in cellNames:
		cellData = LineEdit.new()
		if (data[cellName] != null):
			cellData.text = String(data[cellName])
		cellData.rect_min_size.x=70
		cellData.connect("focus_exited",self,"_on_cell_modified",[cellData])
		cellData.connect("focus_entered",self,"_on_cell_selected",[cellData])
		myLine.add_child(cellData)
	table.add_child(myLine)

func _refresh_table():
	#clear all lines and cells
	for lines in table.get_children():
		lines.queue_free()
	cellNames = []
		
	#get cell list
	data_db.query("PRAGMA table_info("+ data_tablename + ");")
	#fisrt line with cells names
	var myLine=HBoxContainer.new()
	for field in data_db.query_result:
		var cellTitle = Button.new()
		cellTitle.text = field["name"]
		cellTitle.rect_min_size.x=70
		myLine.add_child(cellTitle)
		cellNames.append(field["name"])
		#myFieldcell.get_node("Label").text=field["name"]
	table.add_child(myLine)

	#todo hsplit : prb il faudrait ajouter les données en colonnes et là j'ajoute des lignes

	#parse data , todo with pagination
	var cellData
	data_db.query("SELECT * from "+ data_tablename + ";")
	for data in data_db.query_result:
		print(data)
		_add_line(data)
		
	data_db.query("SELECT count(*) from "+ data_tablename + ";")
	nbRecords.text = "Nb Records : "+String(data_db.query_result[0].values()[0])
	

extends Tabs

onready var container := $VBoxContainer/ScrollContainer
onready var table := $VBoxContainer/ScrollContainer/Table
onready var nbRecords := $VBoxContainer/Pagination/NbRecords

var cellNames = []

	
func _ready():
	pass

###################
# Internal signals
###################

func _on_AddLine_pressed():
	#todo refacto for line add method
	var myLine=HBoxContainer.new()
	var cellData
	
	# add a new line
	for cellName in cellNames:
		cellData = LineEdit.new()
		cellData.text = ""
		cellData.rect_min_size.x=70
		cellData.connect("text_entered",self,"_on_cell_modified")
		myLine.add_child(cellData)
	table.add_child(myLine)
	
	# insert request
	
#add signel on cell data edit to update the record
func _on_cell_modified(val):
	print(val)
	
#todo add signal to change color when cell in select and modif not applied

###################
# External signals
###################

func _on_data_list(db,table_name):
	print("get datas")
	#get cell list
	db.query("PRAGMA table_info("+ table_name + ");")
	
	#clear all lines and cells
	for lines in table.get_children():
		lines.queue_free()
	cellNames = []
		
	#fisrt line with cells names
	var myLine=HBoxContainer.new()
	for field in db.query_result:
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
	db.query("SELECT * from "+ table_name + ";")
	for data in db.query_result:
		# add a new line
		myLine=HBoxContainer.new()
		for cellName in cellNames:
			cellData = LineEdit.new()
			if (data[cellName] != null):
				 cellData.text = String(data[cellName])
			cellData.rect_min_size.x=70
			cellData.connect("text_entered",self,"_on_cell_modified")
			myLine.add_child(cellData)
		table.add_child(myLine)
		
	db.query("SELECT count(*) from "+ table_name + ";")
	print(db.query_result)
	nbRecords.text = "Nb Records : "+String(db.query_result[0]["count(*)"])
	

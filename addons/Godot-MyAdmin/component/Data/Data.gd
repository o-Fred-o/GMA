extends Tabs

onready var container := $VBoxContainer/ScrollContainer
onready var table := $VBoxContainer/ScrollContainer/Table
onready var line := $VBoxContainer/ScrollContainer/Table/Line

func _ready():
    pass

func _on_data_list(db,table_name):
    print("get datas")
    #get column list
    db.query("PRAGMA table_info("+ table_name + ");")
    
    
    #clear all columns
#    for child in columns.get_children():
#        child.queue_free()


    #for each info
    for field in db.query_result:
        var myLine=line.duplicate()
        var columnTitle = Button.new()
        columnTitle.text = field["name"]
        myLine.add_child(columnTitle)
        #myFieldColumn.get_node("Label").text=field["name"]
        table.add_child(myLine)


#    # add a new line
#    container.add_child(columns.duplicate())
#    #parse data with pagination
#    db.query("SELECT * from "+ table_name + ";")
#    for data in db.query_result:
#        var myFieldColumn=columnBase.duplicate()
#        var columnData = LineEdit.new()
#        #get column names !!! 
#        columnData.text = String(data["id"])
#        myFieldColumn.add_child(columnData)
#        columns.add_child(myFieldColumn)
        
    
    #print(db.query_result)
    #[{id:1, nom:rezz, prenom:rez}, {id:2, nom:gfd, prenom:gfdgf}, {id:3, nom:vvv, prenom:ffrfrfr}]
    

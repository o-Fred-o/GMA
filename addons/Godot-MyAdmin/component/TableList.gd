tool extends VBoxContainer

signal selected_table(database,table_name)

var database

###################
# Internal signals
###################

func _on_Add_pressed():
    _create_table(database,$TableName.text)

func _on_Remove_pressed():
    var tree = $Tree
    var item=tree.get_selected()
    _remove_table(database,item.get_text(0))
    
func _on_Tree_item_selected():
    var tree = $Tree
    var item=tree.get_selected()
    emit_signal("selected_table",database,item.get_text(0))
        

###################
# External signals
###################

func _on_open_database(db):
    database=db
    _refresh_list(db)

###################
# Functions
###################

func _refresh_list(db):
    db.query("SELECT name FROM sqlite_master WHERE type ='table' AND name NOT LIKE 'sqlite_%';")
    var result=db.query_result
    var tree = $Tree
    tree.clear()
    var root = tree.create_item()
    tree.set_hide_root(true)
    for tablename in result:    
        var child = tree.create_item(root)
        child.set_text(0,tablename.name)
        
func _create_table(db,table_name):
    #create table with empty structure
    var structure : Dictionary = Dictionary()
    structure["id"] = {"data_type":"int", "primary_key": true, "not_null": true}
    
    db.create_table(table_name, structure)
    _refresh_list(db)

func _remove_table(db,table_name):
    print(table_name)
    db.drop_table(table_name)
    _refresh_list(db)

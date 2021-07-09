tool extends VBoxContainer

signal create_table(table_name)
signal get_database_list()

func _ready():
    pass

func _on_Add_pressed():
    emit_signal("create_table",$TableName.text)
    emit_signal("get_database_list")

func _on_list_refresh(result):
    var tree = $Tree
    tree.clear()
    var root = tree.create_item()
    tree.set_hide_root(true)
    for tablename in result:    
        var child = tree.create_item(root)
        child.set_text(0,tablename.name)

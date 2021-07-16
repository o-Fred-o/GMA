extends Control

var db
var db_name := "res://data/test"

#onready var task_item := $MarginContainer/VBoxContainer/TaskItem
onready var task_list := $MarginContainer/VBoxContainer/TaskList


func _ready():
    db = Global.SQLite.new()
    
    #todo get tasks from db
    var tmp = TaskModel.new("test 1")
    task_list._add_task_to_list(tmp)

    
#    db.path = db_name
#    db.verbose_mode = true
#    db.open_db()

#    var user_dict = UserDict.new()
#    db.create_table(user_table, user_dict.structure)
#    user_dict.add_data()

#   db.insert_row(user_table, user_dict.data)

#   db.query("SELECT * FROM task;")
#   db.query_result

#    db.close_db() 
    
##connect signal from taskItem to TaskList
#    Events.connect("task_remove", task_list, "_remove_task_from_list")
#    Events.connect("task_add", task_list, "_add_task_to_list")
    

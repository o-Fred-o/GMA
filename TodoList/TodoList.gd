extends Control

onready var task_item := $MarginContainer/VBoxContainer/TaskItem
onready var task_list := $MarginContainer/VBoxContainer/TaskList

func _ready():
#connect signal from taskItem to TaskList
    task_item.connect("task_add", task_list, "_add_task_to_list")


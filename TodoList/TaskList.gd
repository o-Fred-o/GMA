extends HBoxContainer

const TASK_ITEM := preload("res://TodoList/TaskItem.tscn")

onready var list_container := $ScrollContainer/TasksContainer

func _ready():
#connect signal from taskItem to TaskList
    Events.connect("task_remove", self, "_remove_task_from_list")
    Events.connect("task_add", self, "_add_task_to_list")

###################
# Functions
###################

func _add_task_to_list(_task : TaskModel):
        var task_item = TASK_ITEM.instance()
        task_item.set_task(_task)
        list_container.add_child(task_item)

func _remove_task_from_list(_instance_id):
    instance_from_id(_instance_id).queue_free()

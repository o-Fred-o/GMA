extends HBoxContainer

const TASK_ITEM := preload("res://TodoList/TaskItem.tscn")

onready var list_container := $ScrollContainer/TasksContainer

func _ready():
    pass

func _add_task_to_list(task : TaskModel):
    if !task.description.empty():
        var task_item = TASK_ITEM.instance()
        task_item.description=task.description
        task_item.myTask=task
        list_container.add_child(task_item)
        #ajoute la donne au modele
        #mise a jour de l'id
        #task.id=task_item.get_instance_id()
        #myList.add_task(task)

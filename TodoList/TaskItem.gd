extends HBoxContainer

export var is_editable : bool = false

onready var task_description := $Description
onready var add_button := $Add_Button
onready var remove_button := $Remove_Button

var task : TaskModel

func _ready():
    if is_editable:
        remove_button.visible=false
    if !is_editable:
        add_button.visible=false
        task_description.editable=false
        
    if (task != null):
        task_description.text=task.description

###################
# Functions
###################

func set_task(_task : TaskModel):
    task=_task
    task.description=_task.description

###################
# Internal signals
###################

func _on_Add_Button_pressed():
    if !task_description.text.empty():
        task = TaskModel.new(task_description.text)
        Events.emit_signal("task_add", task)
        task_description.text=""

func _on_Remove_Button_pressed():
    Events.emit_signal("task_remove", get_instance_id())


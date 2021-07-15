class_name TaskModel extends Object

var id : int
var description : String


func _init(_id: int, _description: String):
    id=_id
    description = _description

func save():
    var save_dict= {
        "id" : id,
        "description" : description
       }
    return save_dict

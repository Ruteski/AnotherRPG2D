extends Node2D
class_name DecorationComponent

@export_category("Variables")
@export var _texture_list: Array[String]


func _ready() -> void:
	for _children in get_children():
		if _children is Sprite2D:
			_children.texture = load(
				_texture_list.pick_random()
			)

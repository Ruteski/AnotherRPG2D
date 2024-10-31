extends DecorationComponent
class_name DecorationSign

func _ready() -> void:
	var _sign_texture: String = _texture_list.pick_random()
	
	if _sign_texture == "res://assets/Decorations/signs/18.png":
		$Texture1.position = Vector2(-64, -128)
	
	$Texture1.texture = load(_sign_texture)

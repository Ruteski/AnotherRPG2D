extends Area2D
class_name LadderArea


func _on_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		if global_position.y > body.global_position.y: # player entrou na montanha
			body.update_mountain_state(true) 
		else: # player saiu na montanha
			body.update_mountain_state(false)

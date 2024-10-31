extends CharacterBody2D
class_name BaseCharacter

var _can_attack: bool = true
var _attack_animation_name: String = ""
var _is_in_mountain: bool = false

@export_category("Variables")
@export var _move_speed: float = 128.0
@export var _overspeed: float = 2.5
@export var _left_attack_name: String = ""
@export var _right_attack_name: String = ""

@export_category("Objects")
@export var _animation: AnimationPlayer
@export var _sprite2d: Sprite2D
@export var _bridge: TileMapLayer


func _ready() -> void:
	update_mountain_state(_is_in_mountain)


func _physics_process(_delta: float) -> void:
	move()
	attack()
	flip_sprite()
	animate()


func attack() -> void:
	if ((Input.is_action_just_pressed("left_attack") || Input.is_action_just_pressed("attack_a"))
		&& _can_attack
	):
		_can_attack = false
		_attack_animation_name = _left_attack_name
		set_physics_process(false)
	elif ((Input.is_action_just_pressed("right_attack") || Input.is_action_just_pressed("attack_b"))
		&& _can_attack
	):
		_can_attack = false
		_attack_animation_name = _right_attack_name
		set_physics_process(false)


func move() -> void:
	# o get_vector automagicamente normaliza o vetor
	var _direction: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	
	if Input.is_action_pressed("overspeed"): 
		velocity = _direction * _move_speed * _overspeed
	else:
		velocity = _direction * _move_speed
	move_and_slide()


func animate() -> void:
	# nao pode atacar, significa que ja clicou pra atacar
	if !_can_attack:
		_animation.play(_attack_animation_name)
		return
	
	# se velocidade é diferente de zero
	if velocity:
		_animation.play("run")
	else:
		_animation.play("idle")


func flip_sprite() -> void:
	if velocity.x > 0:
		_sprite2d.flip_h = false
	elif velocity.x < 0:
		_sprite2d.flip_h = true	


func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack_axe" || anim_name == "attack_hammer":
		_can_attack = true
		set_physics_process(true)


func update_collision_layer_mask(type: String) -> void:
	if type == "in": # player entrando na ponte
		set_collision_layer_value(2, true) # se tornando da layer da ponte
		set_collision_layer_value(1, false) # deixando de ser da layer padrao
		set_collision_mask_value(2, true) # se tornando da mask da ponte
		set_collision_mask_value(1, false) # deixando de ser da mask padrao
	else: # player saind da ponte
		set_collision_layer_value(2, false) # se deixando de ser da layer da ponte
		set_collision_layer_value(1, true) # voltando a ser da layer padrao
		set_collision_mask_value(2, false) # se deixando de ser da mask da ponte
		set_collision_mask_value(1, true) # voltando a ser da mask padrao


func update_mountain_state(state: bool):
	_is_in_mountain = state
	if !_is_in_mountain:
		_bridge.z_index = 1
	else:
		_bridge.z_index = 0


func get_is_in_mountain() -> bool:
	return _is_in_mountain

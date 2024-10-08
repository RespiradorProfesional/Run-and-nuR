extends CharacterBody2D
class_name Player

@onready var camera=$Camera2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	if multiplayer.get_unique_id()==name.to_int():
		$Camera2D.call_deferred("make_current")
	else:
		$Camera2D.enabled=false

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

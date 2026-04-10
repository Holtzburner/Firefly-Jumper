extends CharacterBody2D

@export var speed: float = 200.0
@export var acceleration: float = 1400.0
@export var deceleration: float = 1800.0
@export var jump_velocity: float = -400.0
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

func _physics_process(delta: float) -> void:
	_handle_jump_input(delta)
	_handle_gravity(delta)
	_handle_movement(delta)
	_handle_jump()
	move_and_slide()
	_update_animation()

func _handle_jump_input(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer = max(jump_buffer_timer - delta, 0.0)

func _handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer = max(coyote_timer - delta, 0.0)

func _handle_jump() -> void:
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = jump_velocity
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

func _handle_movement(delta: float) -> void:
	var direction := Input.get_axis("left", "right")

	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
		anim.flip_h = direction < 0.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration * delta)

func _update_animation() -> void:
	if not is_on_floor():
		if velocity.y < 0.0:
			if anim.animation != "Jump":
				anim.play("Jump")
		else:
			if anim.animation != "Fall":
				anim.play("Fall")
		return

	if abs(velocity.x) > 1.0:
		if anim.animation != "Run":
			anim.play("Run")
	else:
		if anim.animation != "Idle":
			anim.play("Idle")


func _on_світлячки_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

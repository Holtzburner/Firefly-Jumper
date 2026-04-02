extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -200.0

# --- Jump feel settings ---
const COYOTE_TIME = 0.12
const JUMP_BUFFER_TIME = 0.12

var coyote_timer := 0.0
var jump_buffer_timer := 0.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# --- Jump buffer / auto-bhop ---
	# Якщо пробіл затиснутий — буфер постійно оновлюється
	if Input.is_action_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer = max(jump_buffer_timer - delta, 0.0)

	# --- Gravity ---
	if not is_on_floor():
		velocity += get_gravity() * delta

	# --- Coyote time ---
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer = max(coyote_timer - delta, 0.0)

	# --- Jump ---
	# Якщо jump є в буфері і ще діє coyote / персонаж на землі
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	# --- Horizontal movement ---
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# --- Flip sprite left/right ---
	if direction > 0:
		anim.flip_h = false
	elif direction < 0:
		anim.flip_h = true

	move_and_slide()

	# --- Animation switching ---
	if abs(velocity.x) > 1:
		if anim.animation != "Run":
			anim.play("Run")
	else:
		if anim.animation != "Idle":
			anim.play("Idle")

extends CharacterBody2D

@export var speed: float = 250.0

@onready var sprite: Sprite2D = $Sprite2D


var animation_time: float = 0.0
var current_force := Vector2.ZERO

const SWIM_FRAMES: int = 7
const SWIM_FPS: float = 10.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	velocity = direction * speed + current_force
	move_and_slide()
	

	if direction != Vector2.ZERO:
		animation_time += delta
		sprite.frame = int(animation_time * SWIM_FPS) % SWIM_FRAMES

		if direction.x != 0:
			sprite.flip_h = direction.x < 0
	else:
		animation_time = 0.0
		sprite.frame = 0
		
func set_current_force(force: Vector2) -> void:
	current_force = force


func clear_current_force() -> void:
	current_force = Vector2.ZERO

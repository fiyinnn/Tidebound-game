extends Area2D

@onready var barrier: StaticBody2D = $Barrier
@onready var exit_visual: Label = $ExitVisual

var is_open: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var main_scene := get_tree().current_scene

		if main_scene.has_method("try_exit"):
			main_scene.call("try_exit")

func open_exit() -> void:
	if is_open:
		return

	is_open = true
	exit_visual.text = "OPEN"

	if is_instance_valid(barrier):
		barrier.call_deferred("queue_free")
		
	

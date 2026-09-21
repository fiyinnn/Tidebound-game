extends Area2D

@export var refill_amount: float = 40.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var main_scene := get_tree().current_scene

		if main_scene.has_method("refill_oxygen"):
			main_scene.call("refill_oxygen", refill_amount)
			queue_free()

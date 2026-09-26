extends Area2D

@export var push_force := Vector2(-90.0, 0.0)


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("set_current_force"):
		body.set_current_force(push_force)


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("clear_current_force"):
		body.clear_current_force()
		

extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var main_scene := get_tree().current_scene

		if main_scene.has_method("collect_seal"):
			main_scene.call("collect_seal")
			queue_free()
			

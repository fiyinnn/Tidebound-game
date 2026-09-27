extends Area2D

@export var is_partner: bool = false

var rescue_check_timer: float = 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)

	print("PARTNER SCRIPT RUNNING")
	print("NODE: ", name, " | IS PARTNER: ", is_partner)
	print("HAS RESCUE FUNCTION: ", get_tree().current_scene.has_method("rescue_partner"))


func _process(delta: float) -> void:
	if not is_partner:
		return

	rescue_check_timer -= delta

	if rescue_check_timer > 0.0:
		return

	rescue_check_timer = 0.25

	var main_scene := get_tree().current_scene
	var player := main_scene.find_child("Player", true, false) as Node2D

	if player != null:
		if global_position.distance_to(player.global_position) <= 100.0:
			_try_rescue(main_scene)


func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return

	var main_scene := get_tree().current_scene

	if is_partner:
		_try_rescue(main_scene)
	elif main_scene.has_method("collect_seal"):
		main_scene.call("collect_seal")
		queue_free()


func _try_rescue(main_scene: Node) -> void:
	if not main_scene.has_method("rescue_partner"):
		return

	var rescued = main_scene.call("rescue_partner")

	if rescued == true:
		queue_free()
		

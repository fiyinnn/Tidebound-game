extends Node2D

@export var max_oxygen: float = 100.0
@export var oxygen_drain_rate: float = 10.0
@export var required_seals: int = 1
@export_file("*.tscn") var next_level: String = ""

var current_oxygen: float
var collected_seals: int = 0

@onready var oxygen_bar: ProgressBar = $HUD/OxygenBar
@onready var seal_label: Label = $HUD/SealLabel


func _ready() -> void:
	current_oxygen = max_oxygen
	oxygen_bar.max_value = max_oxygen
	oxygen_bar.value = current_oxygen
	update_seal_label()


func _process(delta: float) -> void:
	current_oxygen = maxf(
		current_oxygen - oxygen_drain_rate * delta,
		0.0
	)

	oxygen_bar.value = current_oxygen

	if current_oxygen <= 0.0:
		get_tree().reload_current_scene()


func refill_oxygen(amount: float) -> void:
	current_oxygen = minf(
		current_oxygen + amount,
		max_oxygen
	)
	oxygen_bar.value = current_oxygen


func collect_seal() -> void:
	collected_seals += 1
	update_seal_label()

	if collected_seals >= required_seals:
		var level_exit := get_node_or_null("LevelExit")

		if level_exit != null:
			level_exit.call("open_exit")
			

func update_seal_label() -> void:
	seal_label.text = "TIDE SEALS: %d / %d" % [
		collected_seals,
		required_seals
	]

func try_exit() -> void:
	if collected_seals >= required_seals:
		if next_level.is_empty():
			seal_label.text = "LEVEL COMPLETE!"
		else:
			get_tree().call_deferred("change_scene_to_file", next_level)
	else:
		seal_label.text = "EXIT LOCKED - FIND THE TIDE SEAL"
		await get_tree().create_timer(1.5).timeout
		update_seal_label()
		
		

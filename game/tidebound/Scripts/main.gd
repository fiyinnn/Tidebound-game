extends Node2D

@export var max_oxygen: float = 100.0
@export var oxygen_drain_rate: float = 10.0
@export var required_seals: int = 1
@export var requires_partner_rescue: bool = false
@export_file("*.tscn") var next_level: String = ""

var current_oxygen: float
var collected_seals: int = 0
var partner_rescued: bool = false

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
	check_objectives()

func rescue_partner() -> void:
	partner_rescued = true
	seal_label.text = "PARTNER RESCUED!"
	check_objectives()

	await get_tree().create_timer(1.5).timeout
	update_seal_label()

func objectives_complete() -> bool:
	var seals_complete := collected_seals >= required_seals
	var rescue_complete := not requires_partner_rescue or partner_rescued

	return seals_complete and rescue_complete

func check_objectives() -> void:
	if objectives_complete():
		var level_exit := get_node_or_null("LevelExit")

		if level_exit != null:
			level_exit.call("open_exit")

func update_seal_label() -> void:
	seal_label.text = "TIDE SEALS: %d / %d" % [
		collected_seals,
		required_seals
	]

func try_exit() -> void:
	if objectives_complete():
		if next_level.is_empty():
			seal_label.text = "MISSION COMPLETE!"
		else:
			get_tree().call_deferred(
				"change_scene_to_file",
				next_level
			)
	else:
		if collected_seals < required_seals:
			seal_label.text = "EXIT LOCKED - FIND THE TIDE SEALS"
		else:
			seal_label.text = "EXIT LOCKED - RESCUE YOUR PARTNER"

		await get_tree().create_timer(1.5).timeout
		update_seal_label()
		

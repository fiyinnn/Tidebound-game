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

@onready var restart_button: Button = get_node_or_null(
	"HUD/RestartButton"
)

@onready var quit_button: Button = get_node_or_null(
	"HUD/QuitButton"
)

func _ready() -> void:
	current_oxygen = max_oxygen
	oxygen_bar.max_value = max_oxygen
	oxygen_bar.value = current_oxygen
	update_seal_label()

	if restart_button != null:
		restart_button.pressed.connect(_restart_game)

	if quit_button != null:
		quit_button.pressed.connect(_quit_game)

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

func rescue_partner() -> bool:
	if collected_seals < required_seals:
		seal_label.text = "FIND ALL TIDE SEALS FIRST!"
		return false

	partner_rescued = true
	seal_label.text = "PARTNER RESCUED!"
	check_objectives()
	return true

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
			show_win_screen()
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
func show_win_screen() -> void:
	seal_label.text = "MISSION COMPLETE!"
	set_process(false)
	$Player.set_physics_process(false)

	if restart_button != null:
		restart_button.visible = true

	if quit_button != null:
		quit_button.visible = true
func _restart_game() -> void:
	get_tree().change_scene_to_file(
		"res://Scenes/main.tscn"
	)
func _quit_game() -> void:
	get_tree().quit()
		

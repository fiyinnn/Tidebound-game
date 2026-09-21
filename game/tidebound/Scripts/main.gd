extends Node2D

@export var max_oxygen: float = 100.0
@export var oxygen_drain_rate: float = 10.0

var current_oxygen: float

@onready var oxygen_bar: ProgressBar = $HUD/OxygenBar


func _ready() -> void:
	current_oxygen = max_oxygen
	oxygen_bar.max_value = max_oxygen
	oxygen_bar.value = current_oxygen


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

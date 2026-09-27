extends Label

var starting_y: float

func _ready() -> void:
	starting_y = position.y

func _process(_delta: float) -> void:
	position.y = starting_y + sin(Time.get_ticks_msec() * 0.004) * 8.0

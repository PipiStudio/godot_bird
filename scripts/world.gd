extends Node2D

@onready var tube_countdown = $TubeCountdown

@export var tube = preload("res://scns/tube.tscn")

func _process(delta: float) -> void:
    print(tube_countdown.time_left)

func _on_tube_countdown_timeout() -> void:
    var new_tube = tube.instantiate()
    add_child(new_tube)
    
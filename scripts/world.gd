extends Node2D

@onready var tube_countdown = $TubeCountdown

@export var tube = preload("res://scns/tube.tscn")


func _on_tube_countdown_timeout() -> void:
	var type = randi_range(0,3)
	match type:
		0:
			for i in 4:
				create_new_tube(Vector2(800,590 - i * 160))
		1:
			for i in 3:
				create_new_tube(Vector2(800,590 - i * 160))
			create_new_tube(Vector2(800,-590))
		2:
			for i in 2:
				create_new_tube(Vector2(800,590 - i * 160))
			for i in 2:
				create_new_tube(Vector2(800,-590 + i * 160))
		3:
			for i in 4:
				create_new_tube(Vector2(800,-590 + i * 160))
	
func create_new_tube(new_position: Vector2):
	var new_tube: Area2D
	new_tube = tube.instantiate()
	new_tube.position = new_position
	add_child(new_tube)

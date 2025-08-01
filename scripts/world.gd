extends Node2D

@onready var tube_countdown = $TubeCountdown
@onready var canvas = $CanvasLayer
@onready var label = $CanvasLayer/VBoxContainer/Label
@onready var score_text = $CanvasLayer2/Score

@export var is_running:bool = true
@export var tube = preload("res://scns/tube.tscn")

var score: int = 0:
	set(value):
		score = value
		score_text.text = "Score:" + str(score)

func _process(_delta: float) -> void:
	if not is_running:
		canvas.show()
		label.text  = "You died!Your score is " + str(score)
	if score > 60 and score <= 200:
		tube_countdown.wait_time = 1.5
	elif score > 200 and score <= 300:
		tube_countdown.wait_time = 1.2
	elif score > 300:
		tube_countdown.wait_time = 1

func _on_tube_countdown_timeout() -> void:
	if is_running:
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


func _on_deadline_body_entered(body:Node2D) -> void:
	body.health = 0
	body.is_hurt = true

func _on_replay_button_pressed() -> void:
	get_tree().reload_current_scene()

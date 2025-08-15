extends Node2D

@onready var tube_countdown = $TubeCountdown
@onready var canvas = $CanvasLayer
@onready var label = $CanvasLayer/VBoxContainer/Label
@onready var score_text = $CanvasLayer2/VBoxContainer/Score
@onready var health_bar = $CanvasLayer2/VBoxContainer/HealthBar
@onready var bird = $Bird

@export var is_running:bool = true
@export var tube = preload("res://scns/tube.tscn")

var score: int = 0:
	set(value):
		score = value
		score_text.text = "分数:" + str(score)

var is_highest_score = false

func _ready() -> void:
	health_bar.max_value = bird.health
	bird.connect("hurt",_pending_hurt)
	bird.connect("heal",_pending_heal)
	bird.connect("die",_game_over)

func _process(_delta: float) -> void:
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
	new_tube.connect("score_add",_add_score)
	new_tube.position = new_position
	add_child(new_tube)


func _on_deadline_body_entered(body:Node2D) -> void:
	body.health = 0
	body.is_hurt = true

func _on_replay_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scns/main_menu.tscn")

func _pending_heal(new_value):
	bird.heal_audio.play()
	health_bar.value = new_value

func _pending_hurt(new_value):
	bird.hurt_audio.play()
	health_bar.value = new_value

func _game_over():
	is_running = false
	canvas.show()
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	if !is_highest_score:
		label.text  = "你死了！你的分数是" + str(score)
	if score > config.get_value("Game","high_score"):
		is_highest_score = true
		config.set_value("Game","high_score",score)
		config.save("user://config.cfg")
		label.text  = "你突破了最高分！你的分数是" + str(score)

func _add_score(tube_remove):
	score += 1
	tube_remove.queue_free()
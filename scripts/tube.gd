extends Area2D

signal score_add(tube)

@export var velocity:int = 500

@onready var world = $"../"

func _physics_process(delta: float) -> void:
	position.x -= velocity * delta
	if position.x < -900 and world.is_running:
		score_add.emit(self)
		'''world.score += 1
		queue_free() '''

func _on_body_entered(body:Node2D) -> void:
	body.is_hurt = true
	body.hurt_audio.play()

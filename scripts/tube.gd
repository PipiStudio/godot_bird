extends Area2D

func _process(delta: float) -> void:
    position.x -= 500 * delta 

func _on_body_entered(body:Node2D) -> void:
    body.is_hurt = true


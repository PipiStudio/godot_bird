extends CharacterBody2D

signal hurt(new_value)
signal die

enum STATE {
	IDLE,
	JUMP,
	HURT,
	DEAD,
}

@export var default_jump_force = 300
@export var is_hurt = false
@onready var skill_timer = $SkillTimer
@onready var jump_audio = $JumpAudio
@onready var hurt_audio = $HurtAudio
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var health = 3:
	set(value):
		health = value
		hurt_audio.play()
		hurt.emit(health)
var jump_force = default_jump_force

var current_state: STATE = STATE.IDLE

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	var config = ConfigFile.new()
	config.load("user://config.cfg")
	var skill = config.get_value("Game", "skill")
	init_skill(skill)
	activate_skill(skill)

## TODO 如果有必要，我可能需要进一步拆分一个函数专门管理动画，看情况
func _physics_process(delta: float) -> void:
	change_state()

	# 跳跃逻辑
	if Input.is_action_just_pressed("jump") and position.y > -550 and current_state != STATE.DEAD:
		velocity.y = - jump_force
		jump_audio.play()
	else:
		velocity.y += get_gravity().y * delta * 0.5

	match current_state:
		STATE.IDLE:
			animation_player.play("idle")
			jump_force = 1.25 * default_jump_force
		STATE.JUMP:
			animation_player.play("jump")
			jump_force = default_jump_force
		STATE.HURT:
			animation_player.play("hurt")
		STATE.DEAD:
			die.emit()
			animation_player.play("dead")
			
	move_and_slide()

func decrease_health(decrease):
	health -= decrease

## 这个函数用于处理角色状态转换，不处理实际状态逻辑，请移步_physics_process
func change_state():
	match current_state:
		STATE.IDLE:
			if velocity.y <= 0:
				current_state = STATE.JUMP
			if is_hurt:
				current_state = STATE.HURT
		STATE.JUMP:
			if velocity.y > 0:
				current_state = STATE.IDLE
			if is_hurt:
				current_state = STATE.HURT
		STATE.HURT:
			if not is_hurt:
				current_state = STATE.IDLE
			if health <= 0:
				current_state = STATE.DEAD
		
func init_skill(game_skill):
	match game_skill:
		0:
			health = 8
		1, 3:
			pass
		2:
			var smaller_shape = RectangleShape2D.new()
			smaller_shape.set_size(Vector2(20,20))
			collision_shape.set_shape(smaller_shape)

func activate_skill(game_skill):
	match game_skill:
		0, 2, 3:
			skill_timer.stop()
		1:
			skill_timer.start()

func _on_skill_timer_timeout() -> void:
	health += 1

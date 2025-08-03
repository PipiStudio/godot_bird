extends CharacterBody2D

enum STATE{
    IDLE,
    JUMP,
    HURT,
    DEAD,
}

@export var default_jump_force = 300
@export var is_hurt = false
@onready var world = $"../"
@onready var skill_timer = $SkillTimer

@export var health = 3:
    set(value):
        health = value
        $"../CanvasLayer2/VBoxContainer/HealthBar".value = health
var jump_force = default_jump_force
var is_health_skill = false # 生生不息技能

var current_state: STATE = STATE.IDLE

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
    check_skill()
    

## TODO 如果有必要，我可能需要进一步拆分一个函数专门管理动画，看情况
func _physics_process(delta: float) -> void:
    change_state()

    # 跳跃逻辑
    if Input.is_action_just_pressed("jump") and world.is_running and position.y > -550:
        velocity.y = -jump_force
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
            is_health_skill = false
            world.is_running = false
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
        
func check_skill():
    var config = ConfigFile.new()
    config.load("user://config.cfg")
    if config.get_value("Game","skill") == 0:
        health = 7
    if config.get_value("Game","skill") == 1:
        is_health_skill = true

func _on_skill_timer_timeout() -> void:
    print(1)
    if is_health_skill:
        health += 1
        print(2)

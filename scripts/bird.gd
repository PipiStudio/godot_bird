extends CharacterBody2D

enum STATE{
    IDLE,
    JUMP,
    HURT,
    DEAD,
}

@export var default_jump_force = 300
@export var is_hurt = false

var health = 3
var jump_force = default_jump_force

var current_state: STATE = STATE.IDLE

@onready var animation_player = $AnimationPlayer

## TODO 如果有必要，我可能需要进一步拆分一个函数专门管理动画，看情况
func _physics_process(delta: float) -> void:
    change_state()


    # 跳跃逻辑
    if Input.is_action_just_pressed("jump"):
        velocity.y = -jump_force
    else:
        velocity.y += get_gravity().y * delta * 0.5

    match current_state:
        STATE.IDLE:
            animation_player.play("idle")
            jump_force = 1.25 * default_jump_force
        STATE.JUMP:
            print(111)
            animation_player.play("jump")
            jump_force = default_jump_force
        STATE.HURT:
            animation_player.play("hurt")
        STATE.DEAD:
            queue_free()
            
    move_and_slide()

func decrease_health(decrease):
    health -= decrease

## 这个函数用于处理角色状态转换，不处理实际状态逻辑，请移步_physics_process
func change_state():
    match current_state:
        STATE.IDLE:
            if velocity.y <= 0:
                current_state = STATE.JUMP
        STATE.JUMP:
            if velocity.y > 0:
                current_state = STATE.IDLE
        STATE.HURT:
            if not is_hurt:
                current_state = STATE.IDLE
            if health <= 0:
                current_state = STATE.DEAD
        STATE.IDLE, STATE.JUMP:
            if is_hurt:
                current_state = STATE.HURT

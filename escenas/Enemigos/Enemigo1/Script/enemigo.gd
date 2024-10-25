extends CharacterBody2D

@export var knockback_force: float = 1
@export var damage_blink_time: float = 0.3

@onready var animated_sprite = $AnimatedSprite2D
@onready var hurt_timer = $HurtTimer
@export var health_component: HealthComponentEnemy

var gravity = 10
var speed = -100
var facing_right = false
var is_hurt = false

func _ready():
	animated_sprite.play("walk_left")

func _physics_process(delta):
	if is_hurt:
		position.x = position.x + ((hurt_timer.get_time_left() * 5) * (-1 if facing_right else 1))
		return
	
	if  not is_on_floor():
		velocity.y += gravity + delta
	
	if !$RayCast2D.is_colliding() && is_on_floor() or is_on_wall():
		flip() 
		
	var collider = $RayCast2D.get_collider()
	
	if collider is Node:
		if collider.is_in_group("Enemigo"):
			flip()
	
	velocity.x = speed
	move_and_slide() 


func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1

func _on_health_component_on_dead() -> void:
	queue_free()


func _on_health_component_on_damage_took() -> void:
	is_hurt = true
	hurt_timer.start()
	blink()

func blink() -> void:
	animated_sprite.modulate.a = 0.5
	await get_tree().create_timer(damage_blink_time).timeout
	animated_sprite.modulate.a = 1

func _on_hurt_timer_timeout() -> void:
	is_hurt = false

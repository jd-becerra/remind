extends CharacterBody2D

var gravity = 10
var speed = -100
var facing_right = false

func _ready():
	$AnimatedSprite2D.play("walk_left")

func _physics_process(delta):
	if  not is_on_floor():
		velocity.y += gravity + delta
	
	if !$RayCast2D.is_colliding() && is_on_floor():
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

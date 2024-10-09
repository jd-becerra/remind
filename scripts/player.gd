extends CharacterBody2D

@export var move_speed: float = 200
@export var jump_speed: float = 400

@onready var animation = $AnimatedSprite2D
var is_fascing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Aplicar gravedad antes de mover al personaje
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	jump()
	move_x()
	move_and_slide() # Mueve al personaje y detecta colisiones
	flip()
	update_animations()

func update_animations():
	if not is_on_floor():
		if velocity.y < 0:
			print("Saltando")
		else:
			print("Cayendo")
		return
	
	if velocity.x != 0:
		animation.play("Walk")
	else:
		animation.play("Idle")

func jump():
	# Saltar solo si está en el suelo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed

func flip():
	if (is_fascing_right and velocity.x < 0) or (not is_fascing_right and velocity.x > 0):
		scale.x *= -1
		is_fascing_right = not is_fascing_right

func move_x():
	var input_axis = Input.get_axis("move_left", "move_right")
	velocity.x = input_axis * move_speed

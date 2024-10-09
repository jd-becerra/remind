extends CharacterBody2D

@export var move_speed: float
@export var jump_speed: float
#mandar a llamar el archivo animatedsprite
#onready es la notación para tener la referencia antes que el juego empiece
@onready var animation: AnimationPlayer = get_node("AnimationPlayer")
var is_fascing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	jump(delta)
	move_x()
	flip()
	update_animations()
	move_and_slide()

func _ready():
	print(animation.get_animation("Idle"))
	# animation.play("Idle")

func update_animations():
	if not is_on_floor():
		if velocity.y < 0:
			# animated_sprite.play("jump")
			print("Saltando")
		else:
			# animated_sprite.play("fall")
			print("Cayendo")
		return	
	
	if velocity.x:
		animation.play("Walk")
	else:
		animation.play("Idle")
		
		
		#parámetro
func jump(delta):
	#detectar tecla de salto
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed
		#simular gravedad  
	if not is_on_floor():
		velocity.y += gravity * delta
#giro de personaje
func flip():
	if (is_fascing_right and velocity.x < 0) or (not is_fascing_right and velocity):
		scale.x *= -1
		is_fascing_right = not is_fascing_right

#movimiento horizontal
func move_x():
	var input_axis = Input.get_axis("move_left","move_right")
	velocity.x = input_axis * move_speed

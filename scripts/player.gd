extends CharacterBody2D

@export var move_speed: float = 200
@export var jump_speed: float = 400

@onready var animation = $AnimatedSprite2D
@onready var attack_area = $AttackArea

var is_fascing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	jump()
	move_x()
	move_and_slide()
	flip()
	update_animations()
	atack()

func update_animations():
	if is_attacking:
		return
	
	if not is_on_floor():
		if velocity.y < 0:
			print("Saltando")
		else:
			animation.play("Idle")
		return
	
	if velocity.x != 0:
		animation.play("Walk")
	else:
		animation.play("Idle")

func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_speed

func flip():
	if (is_fascing_right and velocity.x < 0) or (not is_fascing_right and velocity.x > 0):
		scale.x *= -1
		is_fascing_right = not is_fascing_right

func move_x():
	var input_axis = Input.get_axis("move_left", "move_right")
	velocity.x = input_axis * move_speed
	
func atack():
	if Input.is_action_just_pressed("atack_knife") and not is_attacking:
		is_attacking = true
		attack_area.monitoring = true
		attack_area.get_node("CollisionShape2D").disabled = false
		animation.play("Attack")
		animation.connect("animation_finished", Callable(self, "_on_attack_finished"))

func _on_attack_finished():
	is_attacking = false
	attack_area.monitoring = false
	attack_area.get_node("CollisionShape2D").disabled = true
	animation.disconnect("animation_finished", Callable(self, "_on_attack_finished"))

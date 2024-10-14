extends CharacterBody2D

@export var move_speed: float = 200
@export var jump_speed: float = 400
@export var spawn_point: Vector2 = Vector2(121, 93)
@export var max_fall_y: float = 600

@onready var animation = $AnimatedSprite2D
@onready var attack_area = $AttackArea

var is_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	if position.y > max_fall_y:
		position = spawn_point
		velocity = Vector2()

	else:
		jump()

		if is_attacking:
			velocity.x = 0
		else:
			move_x()

		move_and_slide()
		flip()
		update_animations()
		attack()

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
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right

func move_x():
	var input_axis = Input.get_axis("move_left", "move_right")
	velocity.x = input_axis * move_speed

func attack():
	if Input.is_action_just_pressed("attack_knife") and not is_attacking:
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

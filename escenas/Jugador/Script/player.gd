extends CharacterBody2D

@onready var sonido_ataque: AudioStreamPlayer2D = $SonidoAtaque
@onready var sonido_caminar: AudioStreamPlayer2D = $SonidoCaminar
@onready var sonido_saltar: AudioStreamPlayer2D = $SonidoSaltar
@export var move_speed: float = 200
@export var run_speed: float = 300  # Velocidad de correr
@export var jump_speed: float = 400
@export var spawn_point: Vector2 = Vector2(121, 93)
@export var max_fall_y: float = 600

@onready var animation = $AnimatedSprite2D
@onready var attack_area = $HitboxComponent
@onready var health_component = $HealthComponent
@onready var life_animation: AnimatedSprite2D = get_tree().get_root().get_node("/root/Lvl1").get_node("%Life")

var is_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false

# UP, UP, DOWN, DOWN, LEFT, RIGHT
var secret_code = [KEY_UP, KEY_UP, KEY_DOWN, KEY_DOWN, KEY_LEFT, KEY_RIGHT]
var cheat_position = Vector2(10000, 395)

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
			animation.play("Jump")
		else:
			animation.play("Jump")  # Usamos la misma animación para saltar y caer
		return
	
	if velocity.x != 0:
		animation.play("Walk")  # Usamos la misma animación para caminar y correr
	else:
		sonido_caminar.play()
		animation.play("Idle")

func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		sonido_saltar.play()
		velocity.y = -jump_speed

func flip():
	if (is_facing_right and velocity.x < 0) or (not is_facing_right and velocity.x > 0):
		scale.x *= -1
		is_facing_right = not is_facing_right

func move_x():
	var input_axis = Input.get_axis("move_left", "move_right")
	# Cambia la velocidad si se presiona la tecla de correr
	if Input.is_action_pressed("run"):
		velocity.x = input_axis * run_speed
	else:
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
	sonido_ataque.play() 
	attack_area.get_node("CollisionShape2D").disabled = true
	animation.disconnect("animation_finished", Callable(self, "_on_attack_finished"))

func _on_health_component_on_dead() -> void:
	position = spawn_point
	health_component.set_health(3)
	life_animation.play("3")
	call_deferred("_change_to_game_over_scene")

func _change_to_game_over_scene():
	get_tree().change_scene_to_file("res://escenas/Menu Muerte/game_over.tscn")
	
func _on_health_component_on_damage_took() -> void:
	if health_component.current_health == 2:
		life_animation.play("2")
	elif health_component.current_health == 1:
		life_animation.play("1")
	elif health_component.current_health == 0:
		life_animation.play("0")

	self.modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.1).timeout
	self.modulate = Color(1, 1, 1)

func _input(event: InputEvent) -> void:
	# Check if the secret code was entered (it accepts when the code is entered in the correct order)
	if event is InputEventKey and event.pressed:
		if secret_code.size() > 0 and secret_code[0] == event.keycode:
			secret_code.remove_at(0)
			if secret_code.size() == 0:
				position = cheat_position
		else:
			secret_code = [KEY_UP, KEY_UP, KEY_DOWN, KEY_DOWN, KEY_LEFT, KEY_RIGHT]

func heal() -> void:
	print("Healing")
	health_component.restore_health(1)

    # Convert health_component.current_health to string
	var health_string = str(health_component.current_health)
	life_animation.play(health_string)
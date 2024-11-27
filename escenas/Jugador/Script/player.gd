extends CharacterBody2D

@export var move_speed: float = 200
@export var run_speed: float = 300  # Velocidad de correr
@export var jump_speed: float = 400
@export var spawn_point: Vector2 = Vector2(121, 93)
@export var max_fall_y: float = 600

@onready var animation = $AnimatedSprite2D
@onready var attack_area = $HitboxComponent
@onready var health_component = $HealthComponent

var is_facing_right = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_attacking = false
@onready var life_animation: AnimatedSprite2D = get_node("/root/CanvasLayer/Life/AnimatedSprite2D")


func _ready():
	var life_scene = preload("res://escenas/Jugador/life.tscn")  # Carga la escena como PackedScene
	var life_instance = life_scene.instantiate()  # Usa 'instantiate()' en lugar de 'instance()'
	life_animation = life_instance as AnimatedSprite2D  # Asegúrate de que la instancia sea de tipo AnimatedSprite2D



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
	attack_area.get_node("CollisionShape2D").disabled = true
	animation.disconnect("animation_finished", Callable(self, "_on_attack_finished"))

func _on_health_component_on_dead() -> void:
	position = spawn_point
	health_component.set_health(3)
	life_animation.play("3")
	get_tree().change_scene_to_file("res://escenas/Menu Muerte/game_over.tscn")
func _on_health_component_on_damage_took() -> void:
	if health_component.current_health == 2:
		life_animation.play("2")
	elif health_component.current_health == 1:
		life_animation.play("1")
	elif health_component.current_health == 0:
		life_animation.play("0")

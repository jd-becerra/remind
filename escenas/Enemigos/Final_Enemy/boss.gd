extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sonidoGruñido: AudioStreamPlayer2D = $"GruñidoBoss"
@onready var sonidoMuerte: AudioStreamPlayer2D = $MuerteBoss
@onready var dañoEnemigo: AudioStreamPlayer2D = $"dañoBoss"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: HitboxComponentEnemy = $HitboxComponentEnemy
@onready var health_component: HealthComponentEnemy = $HealthComponentEnemy
@onready var hurt_timer = $HurtTimer
@export var damage_blink_time: float = 0.3
@onready var player = get_tree().get_root().get_node("Lvl1").get_node("Player")

var gravity = 10
var speed = -100
var facing_right = false
var is_hurt = false
var is_dead = false
var player_inside = false
var health_player_inside = false
var hurt_time = 0.5

func _ready() -> void:
	sonidoGruñido.play()
	await get_tree().create_timer(1.0).timeout
	sprite.play("idle")

	hitbox.body_entered.connect(_on_Hitbox_body_entered)
	hitbox.body_exited.connect(_on_Hitbox_body_exited)

	health_component.body_entered.connect(_on_health_entered)
	health_component.body_exited.connect(_on_health_exited)

func _physics_process(delta: float) -> void:
	if health_component.current_health <= 0:
		queue_free()

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if not player_inside:
		sprite.play("idle")
	else:
		sprite.play("Skill")

	if health_player_inside:
		if player.is_attacking:
			if hurt_time > 0:
				hurt_time -= delta
			else:
				health_component.take_damage(1)
				hurt_time = 0.5

				sprite.modulate = Color(1, 0, 0, 0.5)
				await get_tree().create_timer(0.5).timeout
				sprite.modulate = Color(1, 1, 1, 1)

func _on_health_component_on_dead() -> void:
	sprite.play("death")
	is_dead = true
	await get_tree().create_timer(0.3).timeout
	sonidoMuerte.play()

func _on_health_component_on_damage_took() -> void:
	dañoEnemigo.play()
	is_hurt = true
	if is_dead == false:
		hurt_timer.start()
	blink()

func blink() -> void:
	sprite.modulate.a = 0.5
	await get_tree().create_timer(damage_blink_time).timeout
	sprite.modulate.a = 1
 
func _on_hurt_timer_timeout() -> void:
	is_hurt = false

func _on_Hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.health_component.take_damage(1)
		sprite.play("Skill")
		player_inside = true

func _on_Hitbox_body_exited(body):
	if body.is_in_group("player"):
		sprite.play("idle")
		player_inside = false

func _on_health_entered(body):
	print("Node inside: ", body.name)
	if body.is_in_group("player"):
		health_player_inside = true

func _on_health_exited(body):
	if body.is_in_group("player"):
		health_player_inside = false
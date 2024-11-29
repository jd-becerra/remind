extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var sonidoGruñido: AudioStreamPlayer = $"GruñidoBoss"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	sonidoGruñido.play()
	await get_tree().create_timer(1.0).timeout
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

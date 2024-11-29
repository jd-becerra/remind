extends CharacterBody2D

@export var SPEED: float = 200
@export var despawn_pos_x = 344

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction: float
var spawn_pos: Vector2
var spawn_rot: float

func _ready() -> void:
	global_position = spawn_pos
	global_rotation = spawn_rot
	sprite.play("Iddle")

func _physics_process(_delta: float) -> void:
	if global_position.x < despawn_pos_x:
		queue_free()
		return
	
	velocity = Vector2(0, -SPEED).rotated(direction)
	move_and_slide()
extends Node2D

@onready var camera_animation: Camera2D = %Camara_Animacion
@onready var camera_player: Camera2D = %Camera_Jugador

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var animation_player = $AnimationPlayer
	animation_player.play("Inicio")
	
	# Set camera_animation as the current camera
	camera_animation.enabled = true
	camera_player.enabled = false

	animation_player.animation_finished.connect(_on_inicio_animation_finished)

func _on_inicio_animation_finished() -> void:
	# Set camera_player as the current camera
	camera_animation.enabled = false
	camera_player.enabled = true
	

extends Node2D

@onready var musica_nivel1: AudioStreamPlayer = %NivelMusica
@onready var camera_animation: Camera2D = %Camara_Animacion
@onready var camera_player: Camera2D = %Camera_Jugador
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	animation_player.play("Inicio")
	%Skip.pressed.connect(_on_skip_pressed)
	
	# Set camera_animation as the current camera
	camera_animation.enabled = true
	camera_player.enabled = false

	animation_player.animation_finished.connect(_on_inicio_animation_finished)

func _on_inicio_animation_finished(_anim_name) -> void:
	# Set camera_player as the current camera
	camera_animation.enabled = false
	camera_player.enabled = true
	%Protagonista_Animacion.visible = false
	%Skip.visible = false
	%Player.visible = true

func _on_skip_pressed() -> void:
	# Jump to the end of the animation
	var anim_len = animation_player.current_animation_length
	animation_player.seek(anim_len - 0.1, true)

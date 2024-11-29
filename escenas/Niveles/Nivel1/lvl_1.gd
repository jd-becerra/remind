extends Node2D

@onready var musica_nivel1: AudioStreamPlayer = %NivelMusica
@onready var camera_animation: Camera2D = %Camara_Animacion
@onready var camera_player: Camera2D = %Camera_Jugador
@onready var animation_player = $AnimationPlayer
var enemycounter
var currentenemycounter = 12
@onready var counter = $CanvasLayer/EnemigosCounter
var retry = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("Inicio")
	%Skip.pressed.connect(_on_skip_pressed)
	enemycounter = $Enemigos.get_child_count()
	
	# Set camera_animation as the current camera
	camera_animation.enabled = true
	camera_player.enabled = false

	animation_player.animation_finished.connect(_on_inicio_animation_finished)
	%ConfigBtn.pressed.connect(_on_config_pressed)

	if retry:
		# go to the end of the animation
		animation_player.seek(animation_player.current_animation_length - 0.1, true)
	
func _physics_process(_delta: float) -> void:
	enemycounter = currentenemycounter - $Enemigos.get_child_count()
	counter.text = str(enemycounter) + "/11"
	if enemycounter == 11:
		get_tree().change_scene_to_file("res://escenas/Menu Muerte/victory.tscn")
	

func _on_inicio_animation_finished(_anim_name) -> void:
	retry = true
	# Set camera_player as the current camera
	camera_animation.enabled = false
	camera_player.enabled = true
	counter.show()
	%Protagonista_Animacion.hide()
	%Skip.hide()
	%Player.show()
	%Life.show()

	%Barrera.show()

func _on_skip_pressed() -> void:
	retry = true
	# Jump to the end of the animation
	var anim_len = animation_player.current_animation_length
	animation_player.seek(anim_len - 0.1, true)

func _on_config_pressed() -> void:
	%ConfigMenu.show()
	get_tree().paused = true	

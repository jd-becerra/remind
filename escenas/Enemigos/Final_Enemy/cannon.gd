extends Node2D
@onready var sonidoProyectil: AudioStreamPlayer2D = $"../Proyectil"

## Set the interval of time between each shot
@export var interval = 5.0

@onready var main = get_tree().get_root().get_node("Lvl1")
@onready var boss = get_parent().get_parent()
@onready var projectile = load("res://escenas/Enemigos/Final_Enemy/Summon/summon.tscn")
var counter = 0

func _ready() -> void:
	counter = interval

# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
	# Shoot according to the interval
	if counter > 0:
		counter -= delta
		if counter <= 0:
			shoot()
			# Get new random interval in between (interval - 1) and (interval + 1)
			counter = interval + randf_range(-1, 1)


func shoot():
	print(boss.name)
	sonidoProyectil.play()
	var instance = projectile.instantiate()
	instance.direction = rotation
	instance.spawn_pos = global_position
	instance.spawn_rot = rotation
	boss.add_child(instance)

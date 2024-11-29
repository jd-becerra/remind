extends Area2D

@onready var MusicaNivel = %NivelMusica
var test = 0;

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if test == 0:
			test = 1
			MusicaNivel.queue_free()
			

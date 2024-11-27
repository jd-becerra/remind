extends Control

func _on_btn_reiniciar_pressed() -> void:
	# Reinicia la escena
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/Niveles/Nivel1/lvl_1.tscn")

func _on_btn_exit_pressed() -> void:
	get_tree().quit()

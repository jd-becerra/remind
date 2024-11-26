extends Control

var primer_nivel = preload("res://escenas/Niveles/Nivel1/lvl_1.tscn")

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_packed(primer_nivel)


func _on_exit_pressed() -> void:
	get_tree().quit()

extends Control

var primer_nivel = preload("res://escenas/Niveles/Nivel1/lvl_1.tscn")

func _ready() -> void:
	%ConfigBtn.pressed.connect(_on_config_pressed)
	%TutorialBtn.pressed.connect(_on_tutorial_pressed)
	%TutorialClose.pressed.connect(close_tutorial)

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_packed(primer_nivel)


func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_config_pressed() -> void:
	%ConfigMenu.show()

func _on_tutorial_pressed() -> void:
	%Tutorial.show()

func close_tutorial() -> void:
	%Tutorial.hide()
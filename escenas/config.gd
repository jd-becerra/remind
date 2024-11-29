extends Control

# Right now, both buttons redirect to the main menu
@onready var guardar_cambios_btn: Button = %Guardar
@onready var cancelar_btn: Button = %Cancelar
@onready var increase_volume_btn = %Plus
@onready var decrease_volume_btn = %Min
@onready var fullscreen_btn = %FullBtn
@onready var volume_label = %VolumenTxt

@export var main_ui: Control

const VOL_MAX = 20
const VOL_MIN = -50
const VOL_STEPS = 3

var new_volume = 0
var new_fullscreen = false

func _ready() -> void:
	guardar_cambios_btn.connect("pressed", Callable(self, "_on_guardar_cambios_pressed"))
	cancelar_btn.connect("pressed", Callable(self, "_on_cancelar_pressed"))
	increase_volume_btn.pressed.connect(on_increase_volume)
	decrease_volume_btn.pressed.connect(on_decrease_volume)
	fullscreen_btn.pressed.connect(on_fullscreen_toggle)
	%TutorialBtn.pressed.connect(_on_tutorial_pressed)
	%TutorialClose.pressed.connect(close_tutorial)
	%btnExit.pressed.connect(_on_btn_exit_pressed)

	new_volume = Globals.volume
	update_volume_label()
	new_fullscreen = Globals.fullscreen

	# If scene is not Lvl1, hide the btnExit button
	if get_tree().current_scene.name != "Lvl1":
		%btnExit.hide()

func _on_guardar_cambios_pressed() -> void:
	# Save the new settings
	Globals.volume = new_volume
	Globals.fullscreen = new_fullscreen

	fullscreen_btn.button_pressed  = new_fullscreen
	update_fullscreen(new_fullscreen)
	
	redirect_main_menu()

func _on_cancelar_pressed() -> void:
	# Discard the changes
	new_volume = Globals.volume
	new_fullscreen = Globals.fullscreen

	fullscreen_btn.button_pressed  = Globals.fullscreen
	update_volume(new_volume)
	update_volume_label()
	update_fullscreen(Globals.fullscreen)

	redirect_main_menu()

func redirect_main_menu():
	self.hide()
	get_tree().paused = false

func on_increase_volume() -> void:
	if new_volume < VOL_MAX:
		new_volume += VOL_STEPS

		if new_volume > VOL_MAX:
			new_volume = VOL_MAX

		update_volume_label()
		update_volume(new_volume)

func on_decrease_volume() -> void:
	if new_volume > VOL_MIN:
		new_volume -= VOL_STEPS

		if new_volume < VOL_MIN:
			new_volume = VOL_MIN

		update_volume_label()
		update_volume(new_volume)

func update_volume_label():
	# Correct calculation for percentage
	var percentage = int(((new_volume - VOL_MIN) / float(VOL_MAX - VOL_MIN)) * 100)
	volume_label.text = str(percentage) + "%"
	
func on_fullscreen_toggle() -> void:
	var mode := DisplayServer.window_get_mode()
	var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
	new_fullscreen = !new_fullscreen

func update_fullscreen(state):
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if state else DisplayServer.WINDOW_MODE_WINDOWED)


func update_volume(vol_db: int) -> void:
	for node in get_tree().get_nodes_in_group("audio"):
		node.volume_db = vol_db

func _on_tutorial_pressed() -> void:
	%TutorialBtn.hide()
	%Tutorial.show()

func close_tutorial() -> void:
	%Tutorial.hide()
	%TutorialBtn.show()

func _on_btn_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://escenas/Menu Principal/menu.tscn")
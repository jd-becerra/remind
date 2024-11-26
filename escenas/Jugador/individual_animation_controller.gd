extends AnimatedSprite2D

@export var animation_name: String = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if animation_name != "" and  self.animation != animation_name:
		play(animation_name)
		animation_name = ""

extends Sprite2D

func _ready() -> void:
	get_node("AnimationPlayer").play("Float")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.heal()
		queue_free()

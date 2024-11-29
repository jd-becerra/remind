extends Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("Heal"):
		body.heal()
		queue_free()
		
func Heal() -> void:
	health_component.set_health(health_component.current_health+1)

extends Area2D

@export
var speed = 600.

func _process(delta: float) -> void:
	position += transform.basis_xform(Vector2.RIGHT) * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Target"):
		queue_free()
		area.queue_free()

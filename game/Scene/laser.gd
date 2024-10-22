extends Area2D

@export
var speed = 600.

signal incrScore(int, Vector2)

func _process(delta: float) -> void:
	position += transform.basis_xform(Vector2.RIGHT) * speed * delta


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Target"):
		queue_free()
		incrScore.emit(area.value, area.position)
		area.queue_free()
		
	if area.is_in_group("Asteroide"):
		queue_free()

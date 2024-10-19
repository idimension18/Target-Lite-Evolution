extends Area2D

@export
var speed = 600.

func _physics_process(delta: float) -> void:
	position += transform.basis_xform(Vector2.RIGHT) * speed * delta

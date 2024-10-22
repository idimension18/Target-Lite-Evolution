extends Node2D

@export
var time_limit = 2

var timer = 0.
var velocity_y = 10
var startPos = Vector2.ZERO
var value = 0

func _ready() -> void:
	$Label.text = "+" + str(value)
	position = startPos

func _process(delta: float) -> void:
	if timer < time_limit :
		timer += delta
		position = Vector2(startPos.x, position.y - velocity_y)
		velocity_y /= 1.5
	else:
		queue_free()

extends Area2D

var rng = RandomNumberGenerator.new()

var angleSpeed = 0.
var dir = 0
var speed = 200.

func _ready() -> void:
	$img.frame = rng.randi_range(0, 3)
	
	if  rng.randi_range(0, 1) == 0:
		dir = -1
	else :
		dir = 1
	
	angleSpeed = rng.randf_range(100, 360)
	
	position = Vector2(1155 + 55, rng.randf_range(55, 647 - 55))

func _physics_process(delta: float) -> void:
	position += Vector2.LEFT * speed * delta
	rotation_degrees += angleSpeed  * dir * delta

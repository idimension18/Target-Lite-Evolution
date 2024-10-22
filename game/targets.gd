extends Area2D

var rng = RandomNumberGenerator.new()

var taille
var speed = 200.
var value = 0.


func _ready() -> void:
	taille = rng.randf_range(0.3,  1)
	scale = Vector2(taille, taille)
	value = 100 * (1-taille)
	
	position = Vector2(1155 + 55, rng.randf_range(55, 647 - 55))

func _physics_process(delta: float) -> void:
	position += Vector2.LEFT * speed * delta
	

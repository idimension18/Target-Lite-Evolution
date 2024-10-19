extends Node2D

@export
var asteroideRate = 0.01

var rng = RandomNumberGenerator.new()
var laser = preload("res://Scene/laser.tscn")
var asteroide = preload("res://Scene/asteroide.tscn")

func _physics_process(delta: float) -> void:
	if rng.randf() < asteroideRate : 
		add_child(asteroide.instantiate())
	
	

func _on_ship_laser_fired(position: Variant, angle: Variant) -> void:
	var newLaser = laser.instantiate()
	newLaser.position = position
	newLaser.rotation_degrees = angle
	add_child(newLaser)


func _on_active_zone_area_exited(area: Area2D) -> void:
	area.queue_free()

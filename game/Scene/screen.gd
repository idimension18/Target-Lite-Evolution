extends Node2D

var laser = preload("res://Scene/laser.tscn")



func _on_ship_laser_fired(position: Variant, angle: Variant) -> void:
	var newLaser = laser.instantiate()
	newLaser.position = position
	newLaser.rotation_degrees = angle
	add_child(newLaser)

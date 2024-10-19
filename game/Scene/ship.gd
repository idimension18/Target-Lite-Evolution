extends CharacterBody2D

# Genral Data 
@export
var maxSpeed = 5000
@export
var Acceleration = 2500
@export
var AngleSpeed = 360.

# Custom signals 
signal laser_fired(position, angle)

# main update 
func _physics_process(delta: float) -> void:
	# Movements 
	if Input.is_action_pressed("Forward"):
		velocity += Acceleration * transform.basis_xform(Vector2.RIGHT) * delta
		if velocity.length() >= maxSpeed :
			velocity -= Acceleration * transform.basis_xform(Vector2.RIGHT) * delta
			
	var dir = Input.get_axis("LEFT", "RIGHT")
	rotation_degrees += dir * AngleSpeed * delta
	
	# apply movements 
	move_and_slide()
	
	#  Controlling the fire
	if Input.is_action_just_pressed("Forward"):
		$Body/Fire.visible = true
	if Input.is_action_just_released("Forward"):
		$Body/Fire.visible = false
	
	# Firing lasers 
	if Input.is_action_just_pressed("SPACE"):
		laser_fired.emit(position, rotation_degrees)

extends CharacterBody2D

# Genral Data 
@export
var maxSpeed = 5000
@export
var Acceleration = 2500
@export
var AngleSpeed = 360.
@export 
var maxEnergy = 8
@export
var fireConsumption = 1
@export
var laserConsumption = 1
@export
var charge = 2

var is_damaging = false
var is_stunt = false
var stuntSpeed = 100.
var stuntAngle = 0.
var life = 3
var energy = 8.
var targetAngle = 0.
var toggle = false

# Custom signals 
signal laser_fired(position, angle)
signal reset
signal lostLife(int)

func control(delta: float) -> void:
	# Movements 
	if Input.is_action_pressed("Forward") && energy > 0:
		velocity += Acceleration * transform.basis_xform(Vector2.RIGHT) * delta
		energy -= fireConsumption * delta
		if velocity.length() >= maxSpeed :
			velocity -= Acceleration * transform.basis_xform(Vector2.RIGHT) * delta
	
	if not toggle:
		var dir = Input.get_axis("LEFT", "RIGHT")
		rotation_degrees += dir * AngleSpeed * delta
	
	#  Controlling the fire
	if Input.is_action_just_pressed("Forward") :
		$Body/Fire.visible = true
	if Input.is_action_just_released("Forward") || energy <= 0:
		$Body/Fire.visible = false
		
	# Firing lasers 
	if Input.is_action_just_pressed("SPACE") && energy > laserConsumption:
		laser_fired.emit(position, rotation_degrees)
		energy -= laserConsumption
	
	if toggle:
		var dirY = Input.get_axis("UPS", "DOWNS")
		var dirX = Input.get_axis("LEFTS", "RIGHTS")
		if not (dirY == 0 && dirX == 0):
			targetAngle = Vector2(dirX, dirY).angle()
	
	if Input.is_action_just_pressed("TOGGLE_BOARD"):
		toggle = true
	if Input.is_action_just_pressed("TOGGLE_PAD"):
		toggle = false

# main update 
func _physics_process(delta: float) -> void:
	if not is_stunt:
		control(delta) 
		
	# apply movements 
	move_and_slide()
	
	if toggle:
		rotation = rotate_toward(rotation, targetAngle, delta*8)
	
	# je sait pas ou le mettre
	if $Spark.frame == 17:
		$Spark.visible = false
		$Spark.stop()
	
	# sa non plus 
	if $Blow.frame == 27:
		$Blow.visible = false
		$Blow.stop()
		reset.emit()
	
	# Energy management
	if not Input.is_action_pressed("Forward") && energy < maxEnergy && not is_stunt:
		energy += charge * delta
	if energy < 0:
		energy = 0
	if energy > maxEnergy:
		energy = maxEnergy


# Damage and dying
# -------------------
func damaging():
	if not is_damaging:
		is_damaging = true
		life -= 1
		lostLife.emit(life)
		if life > 0:
			damage()
		else:
			die()

func damage():
	$Damage.play()
	$Spark.visible = true
	$Spark.play()
	is_damaging = true
	blink()
	stuntAngle = rotation_degrees
	stunt()
	await get_tree().create_timer(3.0).timeout
	is_damaging = false


func stunt():
	$Body/Fire.visible = false
	is_stunt = true
	velocity = Vector2.LEFT.rotated(stuntAngle) * stuntSpeed
	await get_tree().create_timer(0.3).timeout
	velocity = Vector2(0, 0)
	is_stunt = false


func blink():
	while is_damaging :
		$Body.visible = false
		await get_tree().create_timer(0.2).timeout
		$Body.visible = true
		await get_tree().create_timer(0.2).timeout


func die():
	$Blow2.play()
	rotation_degrees = 0
	is_stunt = true
	$Blow.visible = true
	$Blow.play()
	velocity = Vector2.ZERO
	is_stunt = true
	$Body.visible = false

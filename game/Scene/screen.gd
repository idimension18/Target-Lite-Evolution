extends Node2D

@export
var asteroideRate = 0.7
@export
var targetRate = 0.1
@export
var debritPeriod = 0.9

var rng = RandomNumberGenerator.new()
var laser = preload("res://Scene/laser.tscn")
var asteroide = preload("res://Scene/asteroide.tscn")
var target = preload("res://Scene/target.tscn")
var life = preload("res://Scene/life.tscn")
var scoreInfo = preload("res://Scene/score_info.tscn")

var debritTimer = 0.

var score = 0

func _ready() -> void:
	for i in $Ship.life :
		var tmp = life.instantiate()
		tmp.name = "Life" + str(i)
		tmp.position = Vector2(i*75 + 35, 35)
		add_child(tmp)
	
	$Soundtrack.play()


func _physics_process(delta: float) -> void:
	debritTimer += delta
	if debritTimer > debritPeriod :
		debritTimer = 0.
		if rng.randf() < asteroideRate : 
			add_child(asteroide.instantiate())
		if rng.randf() > 1- targetRate :
			add_child(target.instantiate())
	
	$GUI/BarNormalized.scale = Vector2($Ship.energy/$Ship.maxEnergy, 1)


func _on_ship_laser_fired(laserPos: Variant, angle: Variant) -> void:
	var newLaser = laser.instantiate()
	newLaser.position = laserPos
	newLaser.rotation_degrees = angle
	add_child(newLaser)
	newLaser.incrScore.connect(_updateScore)


func _on_active_zone_area_exited(area: Area2D) -> void:
	area.queue_free()


func _on_ship_reset() -> void:
	get_tree().reload_current_scene()


func _on_ship_lost_life(i:int) -> void:
	var tmp = get_node("Life" + str(i))
	tmp.queue_free()
	if i == 0:
		$Soundtrack.stop()

func _updateScore(value:int, targetPos:Vector2) -> void:
	$Break.play()
	score += value
	if score < 10:
		$GUI/Score.text = "SCORE : 000" + str(score)
	elif score < 100 : 
		$GUI/Score.text = "SCORE : 00" + str(score)
	elif score < 1000 : 
		$GUI/Score.text = "SCORE : 0" + str(score)
	else:
		$GUI/Score.text = "SCORE : " + str(score)
	
	# Spawn score info
	var newInfo = scoreInfo.instantiate()
	newInfo.startPos = targetPos
	newInfo.value = value
	add_child(newInfo)


func _on_soundtrack_finished() -> void:
	$Soundtrack.play()

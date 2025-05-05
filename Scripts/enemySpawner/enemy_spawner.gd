@tool
extends Area2D
class_name enemySpawner

@export var enemies:Array[EnemySpawnerRequest] = []
@export var spawnWaitTime:float = 1.0
@export var shapeRad:float = 16
@export var enable:bool = false

@onready var shape = $CollisionShape2D
@onready var timer = $Timer
@onready var main = $"/root/".get_child(1)

func getRandomPointInCircle() -> Vector2:
	var rad = shape.shape.radius
	var ang = randf() * TAU
	var dis = sqrt(randf()) * rad
	return self.position + Vector2.from_angle(ang) * dis
	
func selectOneByChance():
	var id = -1
	var highstChance:float = 0.0
	for current in enemies:
		if main.killPoint < current.requestPoint:
			continue
		var chance = randf() * current.chance
		if chance >= highstChance:
			highstChance = chance
			id = enemies.find(current)
	if id > -1:
		return enemies[id]
	
func spawnEnemy() -> void:
	if main.currentEnemies < main.maxEnemies:
		var point = getRandomPointInCircle()
		var selected = selectOneByChance()
		var enemy = selected.enemy.instantiate()
		enemy.position = point
		var enemiesNode = main.get_node_or_null("Enemies")
		if enemiesNode:
			enemiesNode.add_child(enemy)

func _ready() -> void:
	shape.shape.radius = shapeRad
	timer.wait_time = spawnWaitTime

func _process(_delta: float) -> void:
	shape.shape.radius = shapeRad
	timer.wait_time = spawnWaitTime
	if !Engine.is_editor_hint():
		timer.wait_time = max(0.1, spawnWaitTime - 0.002 * main.killPoint)
		if enable and timer.is_stopped():
			timer.start()
		elif !enable and !timer.is_stopped():
			timer.stop()

func _on_timer_timeout() -> void:
	if !Engine.is_editor_hint():
		spawnEnemy()

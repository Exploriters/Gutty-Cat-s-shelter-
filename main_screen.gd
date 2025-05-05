extends Node2D
class_name mapBase

@export var maxEnemies:int = 0
var currentEnemies:int = 0

@onready var player = self.get_node_or_null("Player")
@onready var camera = $Camera2D
@onready var restarter = $Camera2D/Restarter
@onready var restarterTimer = $Camera2D/Restarter/restartTimer
@onready var enterPoints = $EnterPoints
@onready var playerSpawnPoint = $PlayerSpawnPoint
@onready var currentDialogue
@onready var enemies =  $Enemies
@onready var shaker = $screenShaker
var killPoint = 0
var killPointPerAnimal = {}

func positionPlayer(target:String) -> void:
	for point in enterPoints.get_children():
		if point is Marker2D and point.name == target:
			player.global_position = point.global_position

func _ready() -> void:
	if SceneManager.PLAYER:
		if player:
			player.queue_free()
		player = SceneManager.PLAYER
		add_child(SceneManager.PLAYER)
		positionPlayer(SceneManager.TARGET)
	if player:
		camera.position = player.position
	else:
		player = preload("res://Characters/Player/Player.tscn").instantiate()
		player.global_position = playerSpawnPoint.global_position
		add_child(player)
		camera.position = player.position
	$Camera2D/Restarter/restartScreenAnim.play("default")

func _process(_delta: float) -> void:
	currentEnemies = enemies.get_child_count()
	if player:
		if player.died and restarterTimer.time_left > 0:
			restarter.modulate = Color(1, 1, 1, 1 - 1/restarterTimer.wait_time * restarterTimer.time_left)
		else:
			if !shaker.is_stopped():
				var offset = 32 * Vector2(randi_range(-1, 1) * shaker.wait_time, randi_range(-1, 1) * shaker.wait_time)
				camera.position = player.position + offset
			else:
				camera.position = player.position

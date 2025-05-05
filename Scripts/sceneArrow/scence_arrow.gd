extends Area2D

@export var targetPath:String
@export var targetPoint:String
@export var direction:int = 0 ## 下、右、上、左

@onready var targetMap = null

@onready var sprite = $AnimatedSprite2D
@onready var main = $"/root/".get_child(1)

var player

func _ready() -> void:
	if targetPath != "":
		targetMap = load(targetPath)
	if direction == 0: #DOWN
		pass
	if direction == 1: #RIGHT
		self.rotation_degrees = -90
	if direction == 2: #UP
		self.rotation_degrees = -180
	if direction == 3: #LEFT
		self.rotation_degrees = -270
	sprite.play("default")

func _physics_process(_delta: float) -> void:
	if player and self.position.distance_to(player.position) <= 64 * 2:
		sprite.visible = true
	else:
		sprite.visible = false
	
	for i in self.get_overlapping_bodies():
		if i == player and targetMap:
			SceneManager.change_scene(self, targetPath, targetPoint)

func _process(_delta: float) -> void:
	player = main.player

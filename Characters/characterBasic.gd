extends CharacterBody2D
class_name characterBasic

@onready var MainSprite = $Sprites/MainSprite
@onready var sprites = $Sprites

@onready var warning = $warningIcon

@onready var navigation = $NavigationAgent2D

@onready var main = $"/root/".get_child(1)
@onready var screenShaker = main.get_node_or_null("screenShaker")
var player

@export var animalName:String
@export var killable = false
@export var moveSpeed:float = 64.0 * 3
@export var states:Array[characterState]
@onready var current_state = states[0]
var moving = false
var movingVec = Vector2(0, 0)
var attacking = false
	
func vectorTo(from:Vector2, to:Vector2):
	return Vector2(to.x - from.x, to.y - from.y)

func randomMove():
	movingVec = Vector2(randf_range(-1.0, 1.0) * moveSpeed, randf_range(-1.0, 1.0) * moveSpeed)

func kill():
	player.soundAttack.pitch_scale = randf_range(0.8, 1.2)
	player.soundAttack.play()
	var blood = preload("res://Resources/groundBloodParticle.tscn").instantiate()
	var gore = preload("res://Resources/goreParticle.tscn").instantiate()
	blood.position = self.position
	gore.position = self.position
	blood.rotate(player.position.angle_to_point(blood.position))
	player.position = self.position
	player.invincibleTimeLeft = 30
	player.inInvincible = true
	screenShaker.start()
	main.get_node("Gores/GroundBloods").add_child(blood)
	main.get_node("Gores/Guts").add_child(gore)
	main.killPoint += 1
	main.killPointPerAnimal.get_or_add(animalName, 0)
	main.killPointPerAnimal[animalName] += 1
	queue_free()

func kill_player():
	player.died = true
	player.visible = false
	player.soundDied.pitch_scale = randf_range(0.8, 1.2)
	player.soundDied.play()
	var blood = preload("res://Resources/groundBloodParticle.tscn").instantiate()
	var gore = preload("res://Resources/goreParticle.tscn").instantiate()
	blood.position = player.position
	gore.position = player.position
	blood.rotate(self.position.angle_to_point(player.position))
	self.position = player.position
	screenShaker.start()
	main.get_node("Gores/GroundBloods").add_child(blood)
	main.get_node("Gores/Guts").add_child(gore)
	SceneManager.updateKillPoint(main.killPoint, main.killPointPerAnimal)
	var restarter = main.camera.get_node("Restarter/restartTimer")
	restarter.start()

func findState(stateName) -> characterState:
	for cur in states:
		if cur.stateName == stateName:
			return cur
	return null

func isCompatibleState(stateName) -> bool:
	var result = false
	for request in current_state.compatibleStates:
		if request == stateName:
			result = true
			break
	return result

func _ready() -> void:
	if findState("intro") and findState("idle"):
		MainSprite.play(findState("intro").animation)
		current_state = findState("intro")
	MainSprite.play(states[0].animation)
	var attackMag = $AttackBox/AttackArea.shape.radius / 32.0
	$AttackBox/circle.scale = Vector2(attackMag, attackMag)

func _process(_delta: float) -> void:
	player = main.player

func _physics_process(_delta: float) -> void:
	if moving:
		velocity = movingVec
		var collide = self.move_and_slide()
		if collide:
			movingVec.x *= -1
			movingVec.y *= -1
	if attacking:
		if player.died:
			MainSprite.play("default")
			moving = false
			attacking = false
		$AttackBox.visible = true
		navigation.target_position = player.global_position
		var currentPosition = self.global_position
		var nextPosition = navigation.get_next_path_position()
		movingVec = currentPosition.direction_to(nextPosition) * moveSpeed
		if player and !player.died and !player.inInvincible and self.global_position.distance_to(player.global_position) <= $AttackBox/AttackArea.shape.radius:
			kill_player()
	else:
		$AttackBox.visible = false
		
	if movingVec.x < 0:
		sprites.scale.x = -1
	else:
		sprites.scale.x = 1
	for i in $ClickBox.get_overlapping_areas():
		if i.is_in_group("userMouse") and killable and Input.is_action_just_pressed("CLICK"):
			kill()
	if player and !player.died and self.position.distance_to(player.position) <= $HurtBox/HurtArea.shape.radius:
		sprites.modulate = Color(1, 0.8, 0.8, 1)
		$TargetIcon.visible = true
		killable = true
	else:
		sprites.modulate = Color(1, 1, 1, 1)
		$TargetIcon.visible = false
		killable = false

var stateAtleastOnce = true
func _on_think_timer_timeout() -> void:
	if !current_state.cantRandomTillEnd and stateAtleastOnce:
		var select = randf()
		var action = states[0]
		for curAct in states:
			if curAct.cantRandom:
				continue
			if curAct.requestRange.x <= select and select <= curAct.requestRange.y:
				action = curAct
		if action != current_state and !isCompatibleState(action.stateName):
			current_state = action
			MainSprite.animation = current_state.animation
		current_state = action
			
func _on_main_sprite_frame_changed() -> void:
	if MainSprite.frame == MainSprite.sprite_frames.get_frame_count(MainSprite.animation) - 1:
		var next = findState(current_state.nextState)
		if next:
			if next != current_state and !isCompatibleState(next.stateName):
				current_state = next
				stateAtleastOnce = false
				moving = false
				attacking = false
				MainSprite.animation = current_state.animation
				_on_think_timer_timeout()
			else:
				stateAtleastOnce = true

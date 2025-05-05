extends CharacterBody2D
class_name Player

@export_category("Nodes")
@export var MainSprite:AnimatedSprite2D
@export var sprites:Node2D
@export_group("Sounds")
@export var soundAttack:AudioStreamPlayer
@export var soundDash:AudioStreamPlayer
@export var soundDied:AudioStreamPlayer
@export_category("Attributes")
@export_group("Dialogues")
@export var inDialogue:bool = false
@export var dialogueWith:Node
@export_group("Stats")
@export var inInvincible:bool = false
@export var died:bool = false

@onready var main = $"/root/".get_child(1)

var state:String = "idle"
var facing = 0 # 0:RIGHT || 1:LEFT
var speed:float = SPEED_BASIC
var slide_colddown:int = 0
var invincibleTimeLeft:int = 0
var invincibleTimeMax = 20

const SPEED_BASIC = 64.0 * 5
const SLIDE_COLDDOWN_MAX = 20

func _ready() -> void:
	MainSprite.play("default")

func _physics_process(_delta: float) -> void:
	if !died:
		if !inDialogue:
			if Input.is_action_pressed("MOVE_LEFT") or Input.is_action_pressed("MOVE_RIGHT") or Input.is_action_pressed("MOVE_UP") or Input.is_action_pressed("MOVE_DOWN"):
				if slide_colddown <= 0:
					state = "run"
				else:
					state = "slide"
				if Input.is_action_pressed("MOVE_LEFT") or Input.is_action_pressed("MOVE_RIGHT"):
					if Input.is_action_pressed("MOVE_LEFT"):
						facing = 1
						velocity.x = -speed
					if Input.is_action_pressed("MOVE_RIGHT"):
						facing = 0
						velocity.x = speed
				else:
					velocity.x = 0
				if Input.is_action_pressed("MOVE_UP") or Input.is_action_pressed("MOVE_DOWN"):
					if Input.is_action_pressed("MOVE_UP"):
						velocity.y = -speed
					if Input.is_action_pressed("MOVE_DOWN"):
						velocity.y = speed
				else:
					velocity.y = 0
				self.move_and_slide()
			else:
				if slide_colddown > 0:
					state = "slide"
				else:
					state = "idle"
			if Input.is_action_just_pressed("MOVE_SLIDE") and slide_colddown <= 0:
				soundDash.play()
				slide_colddown = SLIDE_COLDDOWN_MAX
				invincibleTimeMax = 20
				invincibleTimeLeft = invincibleTimeMax
				inInvincible = true
				speed = SPEED_BASIC * 6
				
		if slide_colddown > 0:
			slide_colddown -= 1
			var t:float = slide_colddown/float(SLIDE_COLDDOWN_MAX)
			speed = SPEED_BASIC + (SPEED_BASIC * 6 - SPEED_BASIC) * pow(t, 1.5)
		else:
			slide_colddown = 0
			speed = SPEED_BASIC
		
		if invincibleTimeLeft > 0:
			invincibleTimeLeft -= 1
		else:
			inInvincible = false
			invincibleTimeLeft = 0
		
func _process(_delta: float) -> void:
	if state == "idle":
		MainSprite.play("default")
	if state == "run":
		MainSprite.play("run")
	if state == "slide":
		MainSprite.play("sliding")
	
	if invincibleTimeLeft > 0:
		self.modulate = Color(1, 1, 1 - 1.0/invincibleTimeMax * invincibleTimeLeft, 1)
	else:
		self.modulate = Color(1, 1, 1, 1)
	
	if facing == 1:
		sprites.scale.x = -1
	else:
		sprites.scale.x = 1

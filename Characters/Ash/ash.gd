extends CharacterBody2D
@onready var MainSprite = $Sprites/MainSprite
@onready var sprites = $Sprites
@onready var interactIcon = $InteractIcon

@onready var main = $"/root/".get_child(1)
var player
var camera

func _ready() -> void:
	MainSprite.play("default")
	
func _process(_delta: float) -> void:
	player = main.player
	camera = main.camera
	
	if player != null:
		if player.position.x < self.position.x:
			sprites.scale.x = -1
		else:
			sprites.scale.x = 1
		if self.position.distance_to(player.position) < 64 and !player.inDialogue:
			interactIcon.visible = true
			if Input.is_action_just_pressed("INTERACT") and !main.currentDialogue:
				var dialogueUI = preload("res://Scripts/dialogue/dialogue_ui.tscn").instantiate()
				var dialogue = preload("res://Characters/Ash/Dialogues/testDialogue.tres")
				dialogueUI.dialogueMain = dialogue
				camera.add_child(dialogueUI)
				main.currentDialogue = dialogueUI
				player.inDialogue = true
				player.dialogueWith = self
		else:
			interactIcon.visible = false

		if player.dialogueWith == self:
			MainSprite.play("talk")
		else:
			MainSprite.play("default")

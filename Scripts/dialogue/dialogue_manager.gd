extends Control

@export_group("UI")
@export var characterNameText:Label
@export var textBox:Label
@export var audioPlayer:AudioStreamPlayer2D

@export_group("对话")
@export var dialogueMain:DialogueGroup

@onready var main = $"/root/".get_child(1)
@onready var uiMain = $UImain

var player
var dialogueIndex := 0
var soundCount = 0
var intro = true

func displayNextDialogue():
	soundCount = 0
	if dialogueIndex + 1 > dialogueMain.dialogueList.size():
		if player:
			player.inDialogue = false
			player.dialogueWith = null
		self.visible = false
		$disappearTimer.start()
		return
	var dialogue := dialogueMain.dialogueList[dialogueIndex]
	characterNameText.text = dialogue.characterName
	textBox.text = dialogue.content
	if dialogue.sound:
		soundCount = len(dialogue.content)/2 + 1
		audioPlayer.stream = dialogue.sound
		audioPlayer.pitch_scale = randf_range(0.8, 1.2)
		audioPlayer.play()
		
	dialogueIndex += 1
		
func _ready() -> void:
	displayNextDialogue()

func _physics_process(_delta: float) -> void:
	if main.currentDialogue and main.currentDialogue != self:
		soundCount = 0
		queue_free()
	if Input.is_action_just_pressed("ESC"):
		if player:
			player.inDialogue = false
			player.dialogueWith = null
		self.visible = false
		$disappearTimer.start()
	if Input.is_action_just_pressed("INTERACT"):
		displayNextDialogue()

func _process(_delta: float) -> void:
	player = main.player
	
	if intro:
		uiMain.position.y = 170 - 10 * pow($introTimer.time_left/$introTimer.wait_time, 2)
	else:
		uiMain.position.y = 170
		
func _on_disappear_timer_timeout() -> void:
	main.currentDialogue = null
	soundCount = 0
	queue_free()

func _on_audio_stream_player_2d_finished() -> void:
	soundCount -= 1
	if soundCount > 0:
		audioPlayer.pitch_scale = randf_range(0.8, 1.2)
		audioPlayer.play()

func _on_intro_timer_timeout() -> void:
	intro = false

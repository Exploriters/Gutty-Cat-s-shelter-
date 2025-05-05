extends Node2D

@export var spewBlood:AnimatedSprite2D
@export var groundBlood:AnimatedSprite2D
@export var bloodSplit:Timer
@export var fadedTimer:Timer

func _ready() -> void:
	var Brandi = randf_range(0.5, 1.5)
	self.scale = Vector2(Brandi, Brandi)
	spewBlood.frame = randi_range(0, 2)
	groundBlood.frame = randi_range(0, 2)

func _process(_delta: float) -> void:
	if spewBlood.scale.x < 1.5:
		spewBlood.scale.x = 0.6 + 0.8 * (1 - pow(1-(bloodSplit.wait_time - bloodSplit.time_left)/bloodSplit.wait_time, 12))
	if spewBlood.position.x > -5:
		spewBlood.position.x = 0 + (-5 * pow((-5 - spewBlood.position.x)/-5, 2))
	spewBlood.modulate = (Color(1,1,1, 1 - pow((fadedTimer.wait_time - fadedTimer.time_left)/fadedTimer.wait_time, 4)))
	groundBlood.modulate = (Color(1,1,1, 1 - pow((fadedTimer.wait_time - fadedTimer.time_left)/fadedTimer.wait_time, 4)))


func _on_timer_timeout() -> void:
	self.get_parent().remove_child(self)

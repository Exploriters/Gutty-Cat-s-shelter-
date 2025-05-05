extends Camera2D

@onready var FPS = $FPS
@onready var kill = $kill
@onready var main = $"/root/".get_child(1)
var BEST_POINT = 0

func _ready() -> void:
	var config = ConfigFile.new()
	var result = config.load("user://score.cfg")
	if result == OK:
		BEST_POINT = config.get_value("score", "最佳总分")

func _process(_delta: float) -> void:
	FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	kill.text = "历史最高击杀数：" + str(BEST_POINT) + "\n击杀数：" + str(main.killPoint)

func _on_restart_timer_timeout() -> void:
	if main.get_tree():
		main.get_tree().reload_current_scene()

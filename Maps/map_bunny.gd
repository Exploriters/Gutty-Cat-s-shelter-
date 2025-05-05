extends mapBase
@onready var  cextra = $CameraExtra
@onready var start = $CameraExtra/start
@onready var score = $CameraExtra/score
@onready var scoreShow = $CameraExtra/showScore
@onready var spawner = $EnemySpawner

func _process(_delta: float) -> void:
	super(_delta)
	cextra.position = Vector2(-576.0, -324.0) + camera.position
	pass

func _on_start_pressed() -> void:
	spawner.enable = true
	start.visible = false
	score.visible = false
	scoreShow.visible = false

func _on_score_pressed() -> void:
	var config = ConfigFile.new()
	var result = config.load("user://score.cfg")
	var totally = ""
	var best = ""
	if result == OK:
		for cur in config.get_value("score", "总共敌人类型"):
			totally += "\n击杀" + cur + "：" + str(config.get_value("score", "总共_" + cur))
		for cur in config.get_value("score", "最佳敌人类型"):
			best += "\n击杀" + cur + "：" + str(config.get_value("score", "最佳_" + cur))
		scoreShow.text = "   ——=== 最佳局表现统计 ===——\n最高击杀数：" + str(config.get_value("score", "最佳总分")) + best + "\n            ——=== 总统计 ===——\n总击杀数：" + str(config.get_value("score", "总分")) + totally
	else:
		scoreShow.text = "存档读取失败！错误码：" + str(result)
	if scoreShow.visible == true:
		scoreShow.visible = false
	else:
		scoreShow.visible = true

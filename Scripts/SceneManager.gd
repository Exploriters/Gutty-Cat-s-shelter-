extends Node

var PLAYER:Player
var TARGET

func updateKillPoint(point, perPoint) -> void:
	var config = ConfigFile.new()
	var result = config.load("user://score.cfg")
	
	if result == OK:
		config.set_value("score", "总分", config.get_value("score", "总分") + point)
		for currentPoint in perPoint:
			var last = config.get_value("score", "总共_" + currentPoint) 
			if !last:
				last = 0
			config.set_value("score", "总共_" + currentPoint, last + perPoint[currentPoint])
		var newArray = config.get_value("score", "总共敌人类型")
		for cur in perPoint.keys():
			if newArray.find(cur) == -1:
				newArray.push_back(cur)
		config.set_value("score", "总共敌人类型", newArray)
		if point > config.get_value("score", "最佳总分") :
			config.set_value("score", "最佳总分", point)
			for currentPoint in perPoint:
				config.set_value("score", "最佳_" + currentPoint, perPoint[currentPoint])
			config.set_value("score", "最佳敌人类型", perPoint.keys())
	else:
		for currentPoint in perPoint:
			config.set_value("score", "总共_" + currentPoint, perPoint[currentPoint])
		config.set_value("score", "总共敌人类型", perPoint.keys())
		config.set_value("score", "最佳总分", point)
		config.set_value("score", "总分", point)
		for currentPoint in perPoint:
			config.set_value("score", "最佳_" + currentPoint, perPoint[currentPoint])
		config.set_value("score", "最佳敌人类型", perPoint.keys())
	config.save("user://score.cfg")
	
func change_scene(from, to:String, target:String) -> void:
	TARGET = target
	if from.player:
		PLAYER = from.player
	else:
		PLAYER = preload("res://Characters/Player/Player.tscn").instantiate()
	PLAYER.get_parent().remove_child(PLAYER)
	from.get_tree().call_deferred("change_scene_to_packed", load(to))

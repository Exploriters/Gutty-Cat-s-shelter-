extends Area2D

func _ready() -> void:
	self.add_to_group("userMouse")

func _process(_delta: float) -> void:
	self.position = get_global_mouse_position()

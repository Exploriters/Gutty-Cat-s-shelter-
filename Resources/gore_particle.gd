extends CPUParticles2D

@export var b1:CPUParticles2D
@export var b2:CPUParticles2D
@export var b3:CPUParticles2D
@export var b4:CPUParticles2D
@export var b5:CPUParticles2D

func _ready() -> void:
	self.emitting = true
	b1.emitting = true
	b2.emitting = true
	b3.emitting = true
	b4.emitting = true
	b5.emitting = true

func _on_finished() -> void:
	queue_free()

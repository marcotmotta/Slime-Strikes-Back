extends GPUParticles3D

var sound = false

func _ready():
	emitting = true

	$SoundEffect.playing = sound

func _on_timer_timeout():
	queue_free()

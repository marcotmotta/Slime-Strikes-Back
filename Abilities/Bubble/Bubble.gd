extends Area3D

var direction = Vector3.FORWARD
var speed = 25
var damage = 10
var ally

func _ready():
	pass # Replace with function body.

func _process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if not body == ally:
		queue_free()

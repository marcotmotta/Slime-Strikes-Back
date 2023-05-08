extends Area3D

var direction = Vector3.FORWARD
var speed = 25
var damage = 10

func _ready():
	pass # Replace with function body.

func _process(delta):
	global_position += direction * speed * delta

func _on_body_entered(body):
	if not body.is_in_group('player'):
		queue_free()

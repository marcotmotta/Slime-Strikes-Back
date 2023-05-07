extends Area3D

var direction = Vector3.FORWARD
var speed = 50
var damage = 10

func _ready():
	pass # Replace with function body.

func _process(delta):
	global_position += direction * speed * delta

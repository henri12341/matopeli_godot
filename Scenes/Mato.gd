extends RigidBody2D

var kulunut_aika = 0
var collisions_disabled = true

func _ready():
	get_node("CollisionShape2D").disabled = true
	pass # Replace with function body.

func _process(delta):
	if collisions_disabled:
		kulunut_aika += delta
		if kulunut_aika > 0.5:
			get_node("CollisionShape2D").disabled = false
			collisions_disabled = false

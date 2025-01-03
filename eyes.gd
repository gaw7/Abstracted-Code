extends Node3D
#This script is to automatically populate a character's body with a springarm3D, and an attached camera.

#for when the spring gets made.
var son = null

##Vaguely, where dhould the eyes be?
@export var targetPos = Vector3(0, 1.25, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_createSpring()
	_createCam()


func _createSpring():
	var s = SpringArm3D.new()
	
	#springarm3d specific
	s.set_shape(SeparationRayShape3D.new())
	s.spring_length = 5
	
	#transforms
	s.rotation.x = deg_to_rad(-30.0)
	s.position += targetPos
	
	#apply
	add_child(s)
	son = s

func _createCam():
	var c = Camera3D.new()
	son.add_child(c)

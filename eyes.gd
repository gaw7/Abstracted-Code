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
	
	#for the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _createSpring():
	var s = SpringArm3D.new()
	
	#springarm3d specific
	s.set_shape(SeparationRayShape3D.new())
	s.spring_length = 5
	
	#transforms
	s.rotation.x = deg_to_rad(0.0)
	s.position += targetPos
	
	#apply
	add_child(s)
	son = s

func _createCam():
	var c = Camera3D.new()
	son.add_child(c)


#for rotating the camera...
##How sensitive should the mouse be, in x,y fashion?
@export var camSens = Vector2(0.1, 0.1)
##how far up can you look? Down?
@export var camLimit = 50.0
var camLevel = 0

enum CamType {AlwaysForward, RotateAround}
##Does the character always have back to camera?
##Does the character only rotate when moving?
@export var CameraMode: CamType 


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		var RotateAroundY = deg_to_rad(-event.relative.x * camSens.x)
		var RotateAroundX = -event.relative.y * camSens.y
		
		if CameraMode == CamType.AlwaysForward:
			_rotY(self.get_parent(), RotateAroundY)
			_rotX(self, RotateAroundX)
		elif CameraMode == CamType.RotateAround:
			_rotY(self, RotateAroundY)
			_rotX(son, RotateAroundX)


func _rotY(axis, rad):
	axis.rotate_y(rad)

func _rotX(axis, dY):
	#var dY = -event.relative.y * camSens.y
	if camLevel+dY >-camLimit && camLevel+dY < camLimit:
		camLevel+=dY
		axis.rotate_x(deg_to_rad(dY))

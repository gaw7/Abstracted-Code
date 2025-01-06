extends Node3D
#This script is to automatically populate a character's body with a springarm3D, and an attached camera.

#for when these get made.
var son = null
var cam = null
var dummy = null

##Vaguely, where should the eyes be?
@export var EyePoint = Vector3(0, 1.25, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_createSpring()
	_createDummy()
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
	s.position += EyePoint
	
	#apply
	add_child(s)
	son = s

#creates a target for the camera to lock-onto.
func _createDummy():
	var target = Node3D.new()
	son.add_child(target)
	dummy = target

func _createCam():
	var c = Camera3D.new()
	self.add_child(c)
	c.name = "eyesCam"
	cam = c
	
	#prevent it from inheriting parent's transforms
	c.top_level = true

#to automate the camera's movement...
func _process(_delta):
	_lerpCamera()

@export var cameraLerpWeight = 0.1
func _lerpCamera():
	var x = _calcCamPos(0)
	var y = _calcCamPos(1)
	var z = _calcCamPos(2)
	
	cam.global_position = Vector3(x,y,z)
	
	#also, lookat
	cam.look_at(self.global_position + EyePoint)

func _calcCamPos(i):
	return lerpf(cam.global_position[i], dummy.global_position[i], cameraLerpWeight)


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
	#move the camera with mouse motion
	if event is InputEventMouseMotion:
		
		var RotateAroundY = deg_to_rad(-event.relative.x * camSens.x)
		var RotateAroundX = -event.relative.y * camSens.y
		
		if CameraMode == CamType.AlwaysForward:
			_rotY(self.get_parent(), RotateAroundY)
			_rotX(self, RotateAroundX)
		elif CameraMode == CamType.RotateAround:
			_rotY(self, RotateAroundY)
			_rotX(son, RotateAroundX)
	
	
	#ain't no way this is the official documentation for this...
	#LISTEN,... just create a custom action at this point, and then use
	#event.is_action_pressed([action name])
	elif event is InputEventKey && event.pressed:
		
		#in the meantime, though, I guess this is where I'll put all my
		#button/key-related inputs for cameras...
		if event.keycode == KEY_Z:
			_recenterCam()


func _rotY(axis, rad):
	axis.rotate_y(rad)

func _rotX(axis, dY):
	if camLevel+dY >-camLimit && camLevel+dY < camLimit:
		camLevel+=dY
		axis.rotate_x(deg_to_rad(dY))

#exactly what it says on the tin.
func _recenterCam():	
	var ry = rotation.y
	
	rotate_y(-ry)
	rotation_degrees.x = -10

#func _lockon(target):
	#pass

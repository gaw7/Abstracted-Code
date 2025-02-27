extends Node3D
#Godot 4.1.1
#Child of a CharacterBody3D
#enables basic, 3D, 3rd Person motion

@export_group("walking, running")
##Basic walking speed. Assumes arrow keys to walk.
@export var walkSpd = 3.0
##If not running, can just set this = to walkSpd. Assumes "shift" is run.
@export var runSpd = 5.0
var isRunning = false		#is set to true when holding the run key.

@export_group("jumping")
##Determines whether or not it will jump at a given input
@export var canJump = false
##The initial jump velocity, to be reduced by gravity each frame
@export var jumpSpd = 5
##How much to drop each frame; by default, 9.81/60
@export var gravity = 0.1635
##... this one is... probably not gonna be needed. Basically, how big is gravity allowed to get.
##Head-down skydiving? ~95m/s, or 1.5833m/frame.
##Or, ~12 seconds to reach. So, at the default gravity, 9.81*12= 117.72
@export var terminalVelocity = 100
##Can you change dir while midair?
@export var canMoveMidair = true

@export_group("Inputs")
##If true, then this will listen to player inputs
@export var isPlayerControlled = false

#parent
@onready var dad = self.get_parent()
var vel:Vector3 #the velocity we will give to the parent

##the character skin
@export var skin:Node3D


#This is to check if using the complimentary Eyes.gd script, found at
# https://github.com/gaw7/Abstracted-Code/blob/main/eyes.gd
var eyes = null
var cam = null
var usingEyes = false
#var usingRotAround = false

func _ready() -> void:
	eyes = get_node("../eyes")
	
	#wait a moment, for everything to create
	await get_tree().create_timer(0.1).timeout
	
	#check for eyes
	if eyes != null:
		usingEyes = true
		cam = get_node("../eyes/eyesCam")
		#if eyes.CameraMode == eyes.CamType.RotateAround:
			#usingRotAround = true



func _process(delta):
	
	if (isPlayerControlled):
	
		#lateral motion
		if dad.is_on_floor() || canMoveMidair:
			var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			var direction
			
			if (usingEyes):
					direction = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			else:
				direction = (dad.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			
		
			#running/walking
			var spd = walkSpd
			if Input.is_key_pressed(KEY_SHIFT):
				spd = runSpd
		
			if direction:
				vel.x = direction.x * spd
				vel.z = direction.z * spd
				
				#change the direction the skin is facing
				#if strafing, do this   v
				#skin.rotation_degrees.y = cam.rotation_degrees.y
				
				#if not strafing, do this    v
				var d = Vector3(1,0,1) * direction + skin.global_position
				#var l = lerp(skin.global_position + Vector3(0,0,-1), d, 0.2)
				skin.look_at(d)
				#skin.rotation_degrees *=  Vector3(0,1,0)
				
				
				
			else:
				vel.x = move_toward(vel.x, 0, spd)
				vel.z = move_toward(vel.z, 0, spd)


		#jumping
					#NOTE: For whatever reason, doesn't work when going up-left or down-right.
		if canJump: #that is, if jumping is allowed in this game.
			if Input.is_action_pressed("ui_accept"):
				if dad.is_on_floor():
					vel.y = jumpSpd
	
	#gravity
	_applyGrav()
	
	#applying everything
	dad.velocity = vel
	dad.move_and_slide()


#gravity
func _applyGrav():
	if !dad.is_on_floor():
		vel.y -= gravity
		
		#terminal velocity
		if vel.y < -terminalVelocity:
			vel.y = -terminalVelocity

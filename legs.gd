extends Node3D
#Godot 4.1.1
#Child of a CharacterBody3D
#enables basic, 3D, 3rd Person motion

#walking, running
@export var walkSpd = 3.0	#basic walking speed. Assumes arrow keys to walk.
@export var runSpd = 5.0	#if no running, can just set this = to walkSpd. Assumes "shift" is run.
var isRunning = false		#is set to true when holding the run key.

#jumping
@export var canJump = false		#determines whether or not it will jump at a given input
@export var jumpSpd = 5			#the initial jump velocity, to be reduced by gravity each frame
@export var gravity = 0.1635	#9.81/60
@export var canMoveMidair = true	#can you change dir while midair?

#inputs
@export var isPlayerControlled = false #if true, then this will listen to player inputs

#parent
@onready var dad = self.get_parent()
var vel:Vector3 #the velocity we will give to the parent



func _process(delta):
	
	if (isPlayerControlled):
	
		#lateral motion
		if dad.is_on_floor() || canMoveMidair:
			var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			var direction = (dad.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
			#running/walking
			var spd = walkSpd
			if Input.is_key_pressed(KEY_SHIFT):
				spd = runSpd
		
			if direction:
				vel.x = direction.x * spd
				vel.z = direction.z * spd
				#visuals.look_at(direction + position)
			else:
				vel.x = move_toward(vel.x, 0, spd)
				vel.z = move_toward(vel.z, 0, spd)


		#jumping
		if dad.is_on_floor():
			if Input.is_action_pressed("ui_accept"):
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

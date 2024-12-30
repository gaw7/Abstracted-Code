extends Node3D
#Godot 4.1.1
#Child of a CharacterBody3D
#enables basic, 3D, 3rd Person motion

#walking, running
@export var walkSpd = 3.0	#basic walking. if no run, mod not this one.

#jumping
@export var canJump = false		#determines whether or not it will jump at a given input
@export var jumpSpd = 5			#the initial jump velocity, to be reduced by gravity each frame
@export var gravity = 0.1635	#9.81/60
@export var canMoveMidair = true	#can you change dir while midair?

#inputs
@export var isPlayerControlled = false #if true, then thiss will listen to inputs

#parent
@onready var dad = self.get_parent()
var vel:Vector3 #the velocity we will give to the parent


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (isPlayerControlled):
	
		#lateral motion
		if dad.is_on_floor() || canMoveMidair:
			var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			var direction = (dad.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
			var spd = walkSpd
			#if running, SPD = runSpd
		
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
	_applyGrav(delta)
	
	#applying everything
	#vel *= delta
	dad.velocity = vel
	dad.move_and_slide()
	
	pass


#gravity
func _applyGrav(d):
	if !dad.is_on_floor():
		vel.y -= gravity

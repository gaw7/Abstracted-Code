extends Area3D

@export_category("The trigger and object")

##What group should this check for to activate?
##Can be a player to activate as a trigger or pressure plate, or a
##weapon/projectile to act as a target.
@export var group:String = "playerGroup"

##What object gets moved/transformed from this?
@export var activatee:Node3D = null

@export_category("The motion of the object")

##how fast should it move?
@export var activateeSpd:float = 1.0

##used for update function
var isActive:bool = false

##Will move to this position.
##FOR THE SAKE OF THIS FIRST TRY (technically 2nd, but whatever),
##this will be in LOCAL SPACE
@export var translation:Vector3 = Vector3.ZERO

##Translation, but for rotation
@export var rot = Vector3.ZERO

##the original position. Used to not Lerp motion, and to return to the original spot.
var ogLoc:Vector3

##the world-space coordinates where this is supposed to go when activated
var destinedLoc:Vector3

@export_category("Reversing the motion")

##Should it only be for so long, and then revert?
@export var waitForReverse:float = 0.0

##used to track reverse motion
var isReversing:bool = false

func _ready() -> void:
	#set the default values
	ogLoc = activatee.global_position
	destinedLoc = ogLoc + translation

func _on_body_entered(body: Node3D) -> void:
	#check for group
	if body.is_in_group(group):
		_activatePlate()

func _activatePlate():
	isActive = true

func _process(delta: float) -> void:
	if isActive:
		if !isReversing:
			#translate the thing
			#activatee.translate(translation * delta * activateeSpd)
			activatee.global_translate(translation * delta * activateeSpd)
			
			#rotate the thing
			_rotateThing(rot)
			
			if translation != Vector3.ZERO:
				if activatee.global_position.distance_to(destinedLoc) <= 0.1:
					isActive = false
					activatee.global_position = destinedLoc
					
					_checkReversal()
		else:
			#that is, IS reversing
			activatee.global_translate(-translation * delta * activateeSpd)
			
			_rotateThing(-rot)
			
			#check if should end it, without checking reversal
			if translation != Vector3.ZERO:
				if activatee.global_position.distance_to(ogLoc) <= 0.1:
					isActive = false
					isReversing = false
					activatee.position = ogLoc


func _rotateThing(v:Vector3):
	activatee.rotate_x(deg_to_rad(v.x))
	activatee.rotate_y(deg_to_rad(v.y))
	activatee.rotate_z(deg_to_rad(v.z))

func _checkReversal():
	if waitForReverse > 0.0:
		await get_tree().create_timer(waitForReverse).timeout
		isReversing = true
		isActive = true

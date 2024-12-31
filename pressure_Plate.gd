extends Area3D
#Have you ever played a game where something happens when you walk onto a button or pressure plate?
#Or how about when you go into a certain hallway, and something happens?
#This code is for things like that. It's to be put on the root, so the exported variables can be customized per instance.




#the objects to be manipulated (moved, rotated, scaled. In that order).
@export_group("Must Be Set")
##Gets the in-tree object to manipulate on trigger
@export var objToMove: NodePath	
##How to move/rotate/scale the object, on trigger?
@export var moveDelta = [Vector3.ZERO, Vector3.ZERO, Vector3.ZERO]
##This is a list of strings. Whenever a body enters this, it will check what groups it's in.
##If ANY of those groups match with ANY of the strings in this variable, it will trigger this... hopefully~
@export var groupsThatCanTrigger = []



@export_group("Repetition?")
##Does this trigger something only once?
@export var oneshot = true
var alreadyShot = false			#if oneshot, prevents a second happening; else, reverses on even triggers

@export_subgroup("If repeating...")
##Set to 0 for instant transformation. This is how long it'll take.
@export var timeUntilTransformed = 1.0	
##after being pressed, must wait this long until it can be pressed again.
@export var cooldown = 1.0
var isCool = true			#helper variable for the cooldown.
##After the transformation is complete, after this long, object will revert back. RECOMMENDED to be longer than the cooldown time.
@export var timeUntilReset = 0.0



func _on_body_entered(body):
	if !alreadyShot || !oneshot:	#either it hasn't been done, or it can be done multiple times.
		
		#is it the right guy?
		if _shouldTrigger(body):
			
			#is the cooldown ready?
			if isCool:
				_activateTrigger(false)
				alreadyShot = true
	_reversePolarity()


#returns bool. Called each time *something* enters the collider. If that is in one of the groups, true.
func _shouldTrigger(b):
	for groups in groupsThatCanTrigger:
		if b.is_in_group(groups):
			return true
	return false


#moves the things by the sepcified amount
func _activateTrigger(calledByReset):
	#print("Done")
	var o = get_node(objToMove)
	
	#loop it for time
	var loops = Engine.get_frames_per_second()
	for i in loops:
		#all of these are -=, instead of +=, because _reversePolarity happens so fast.
		
		#move it
		o.position -= moveDelta[0]/loops
		
		#rotate it
		o.rotation.x -= deg_to_rad(moveDelta[1].x/loops)
		o.rotation.y -= deg_to_rad(moveDelta[1].y/loops)
		o.rotation.z -= deg_to_rad(moveDelta[1].z/loops)
			#. . . I feel like there's a less repetitive way of doing this...
		
		#scale it
		o.scale -= moveDelta[2]/loops
		
		#wait for it
		await get_tree().create_timer(timeUntilTransformed/loops).timeout
	#end of loop
	
	
	if (!oneshot):
		_performCooldown()
		
		if !calledByReset && timeUntilReset != 0:
			_performReset()

#if something is triggered, it goes according to settings.
#But then, if it goes off a second time, maybe it should go back to before.
#Think of this like an elevator; push the button, it goes up; push again, and it comes back down.
func _reversePolarity():
	moveDelta[0] *= -1
	moveDelta[1] *= -1
	moveDelta[2] *= -1


#literally cleanup for repeating the trigger function, called only if not oneshot.
func _performCooldown():
	#cooldown
	isCool = false
	await get_tree().create_timer(cooldown).timeout
	isCool = true

#"tick tock... oops! Didn't get there in time, so it's back to the start..."
func _performReset():
	await get_tree().create_timer(timeUntilReset).timeout
	_reversePolarity()
	_activateTrigger(true)

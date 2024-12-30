extends Area3D
#Have you ever played a game where something happens when you walk onto a button or pressure plate?
#Or how about when you go into a certain hallway, and something happens?
#This code is for things like that. It's to be put on the root, so the exported variables can be customized per instance.


@export var groupsThatCanTrigger = []
	#This is a list of strings. Whenever a body enters this, it will check what groups it's in.
	#If ANY of those groups match with ANY of the strings in this variable, it will trigger this... hopefully~
	
@export var oneshot = true		#does this trigger something only once?
@export var objToMove: NodePath			#gets the in-tree object to manipulate on trigger
@export var moveDelta = [Vector3.ZERO, Vector3.ZERO, Vector3.ZERO]		#how to move/rotate/scale the object, on trigger?

#@export var time = 3.0		#How much time should pass between the start and the end of this motion?

func _on_body_entered(body):
	if _shouldTrigger(body):
		_activateTrigger()

#returns bool. Called each time *something* enters the collider. If that is in one of the groups, true.
func _shouldTrigger(b):
	for groups in groupsThatCanTrigger:
		if b.is_in_group(groups):
			return true
	return false


#moves the things by the sepcified amount
func _activateTrigger():
	print("Done")
	var o = get_node(objToMove)
	
	#move it
	o.position += moveDelta[0]
	
	#rotate it
	o.rotation.x += deg_to_rad(moveDelta[1].x)
	o.rotation.y += deg_to_rad(moveDelta[1].y)
	o.rotation.z += deg_to_rad(moveDelta[1].z)
		#. . . I feel like there's a less repetitive way of doing this...
	
	#scale it
	o.scale += moveDelta[2]

#phew... not to just make it happen over time!

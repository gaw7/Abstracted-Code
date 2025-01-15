extends Control

#The thought behind this script is to access different kinds of "conversations,"
#whether it's an actual dialogue, reading a signpost, or something else entirely.

##holds the name
var labelName
##holds the message(s)
var labelMsg
##Is the background to be made. But ISN'T the background's image.
var bg
##which conversation will happen? This is a dialogue_manager, btw.
@export var convers:Resource
##what index of the conversation?
var ndx = 0

#helps determine when to open a new convo, or else just continue the current one
var isTalking = false
var buttonTalk = "KEY_T"





func _beginConversation() -> void:
	isTalking = true
	_createLabels()
	
	#convers should be given a conversation to be had, already.
	
	ndx = 0
	_nextLine()

func _nextLine():
		
	#check for end of convo
	if ndx == convers.dialogue.size():
		_finishWithConversation()
	
	else:
		_readConversation(convers)
		ndx += 1

func _createLabels():
	var rez = get_viewport().get_visible_rect().size
	#frankly, I want the dialogue to only come up to about 1/3 the screen... so I'll do that.
	
	#make the background, because it's kinda hard to see
	bg = TextureRect.new()
	add_child(bg)
	bg.texture = CanvasTexture.new()
	bg.self_modulate = Color(0.2, 0.2, 0.2, 0.6)
	bg.set_position( Vector2(15, rez.y * 2/3))
	bg.size = Vector2(rez.x - 30, rez.y / 3 - 10)
	
	#make the name slot
	labelName = RichTextLabel.new()
	add_child(labelName)
	
	#change position
	labelName.set_position(Vector2(20, rez.y * 2/3))
	
	#modify size
	labelName.size = Vector2(rez.x - 40, 40)
	
	
	#make the message slot
	labelMsg = RichTextLabel.new()
	add_child(labelMsg)
	#labelMsg.fit_content = true
	
	#change pos
	labelMsg.position += Vector2(20, rez.y * 2/3 + labelName.size.y)
	
	#change size
	labelMsg.size = Vector2(rez.x - 40, rez.y / 3 - labelName.size.y)
	
	#test
	#for i in get_children():
	#	print(i.name)


#used to supply the conversation...
#imagine a signpost, with an area around it.
#while the player character is close enough, it will say, "read".
#So long as the player is within this radius, the sign's dialogue is supplied to this menu.
func _supplyConversation(convo):
	convers = convo

#parses the dialogue, sticks it into the appropriate text boxes
func _readConversation(c):
	labelName.text = c._parseDialogue(ndx, true)
	labelMsg.text = c._parseDialogue(ndx, false)

#used to reset everything, sets convers to null
func _finishConversation():
	if labelName != null:
		labelName.free()
	if labelMsg != null:
		labelMsg.free()
	if bg != null:
		bg.free()
	convers = null
	isTalking = false

#Resets everything, preserves convers. Like, for say, when you're close enough to
#read a sign, and finish reading through it... but wanna read it again.
func _finishWithConversation():
	if labelName != null:
		labelName.free()
	if labelMsg != null:
		labelMsg.free()
	if bg != null:
		bg.free()
	#convers = null
	isTalking = false


#this is somewhat for a way to test the code, ngl.
func _input(event: InputEvent) -> void:
	
	if event is InputEventKey && event.pressed:
		#'T' for 'Talk'
		if event.keycode == KEY_T:
			if convers != null:
				if isTalking:
					_nextLine()
				else:
					_beginConversation()

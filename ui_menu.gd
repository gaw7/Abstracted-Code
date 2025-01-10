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
var convers:Node


#just for testing
func _ready() -> void:
	_beginConversation()


func _beginConversation() -> void:
	_createLabels()
	_findConversation(0)
	_readConversation(convers)

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


func _findConversation(conversationIndex):
	#temporary
	convers = get_child(conversationIndex)

func _readConversation(c):
	for i in c.dialogue.size():
		labelName.text = c._parseDialogue(i, true)
		labelMsg.text = c._parseDialogue(i, false)
		
		#wait a moment, so we can at least see it
		await get_tree().create_timer(4.0).timeout
		
	_finishConversation()


func _finishConversation():
	labelName.free()
	labelMsg.free()
	bg.free()
	convers = null

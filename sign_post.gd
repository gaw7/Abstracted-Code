extends StaticBody3D

#This script is designed to be used in conjunction with the dialogue_conversation resource,
#as well as the dialogue_menu script, both of which are available on my github.
#
#In short, this has a, area3D. When the player, identified by group, enters this area,
#this script will fill in the player's conversation with whatever the sign says.
#And, when the player leaves the readRadius, it will remove itself from the conversation.

##The Conversation that the sign will house.
@export var words:Resource

##The group that the player object is in.
@export var playergroup = "playerGroup"

##If there is a Label3D attached to this, saying something like "Read". Assumed child.
@onready var lab:Label3D = self.get_node("Label3D")


func _on_read_rad_body_entered(body: Node3D) -> void:
	#check if it's the player
	if body.is_in_group(playergroup):
		body.get_node("dialogue_menu")._supplyConversation(words)
		
		#display the text (this is a really roundabout way of doing it.
		if lab != null:
			lab.text = "Read"


func _on_read_rad_body_exited(body: Node3D) -> void:
	if body.is_in_group(playergroup):
		body.get_node("dialogue_menu")._finishConversation()
		
		#"hide" the text
		if lab != null:
			lab.text = ""

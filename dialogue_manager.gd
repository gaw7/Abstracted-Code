extends Control


##IMPORTANT: each element must be in the syntax of   Speaker::Message
##If this isn't done, it won't parse correctly.
@export_multiline var dialogue : Array[String]


func _parseDialogue(index:int, wantSpeaker:bool):
	var source:String = dialogue[index]
	
	var speaker:String = ""
	var message:String = ""
	var foundOne = false
	var foundBoth = false
	
	for c in source:
		if !foundBoth:
			
			#have you found one yet?
			if foundOne:
				if c == ':':
					foundBoth = true
					#that's two : found in a row. Now, get rid of the first one
					speaker = speaker.left(speaker.length()-1)
					continue
				else:
					#I guess the speaker has a : in their name. "Inspector:Gadget"
					foundOne = false
			else:
				if c == ':':
					foundOne = true
			
			
			speaker += c
		
		#else, both have been found
		else:
			message+=c
	#exit the loop
	
	if wantSpeaker:
		return speaker
	else:
		return message
	

extends Control

var _characters = []
var _currentCharID:int

# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	$ButtonLayer/DecisionButtons.connect("recenter_buttons", self, "_recenter_buttons")
	initializeCharacters()
	playGame()


"""
/*
* @pre Called once to initialize Character objects
* @post all characters are added to scene and added to _characters var for ease of access
* @param None
* @return None
*/
"""	
func initializeCharacters():
	var dolores = load("res://Scenes/Character/Character.tscn").instance()
	dolores._charName = "dolores"
	dolores._charID = 0
	var trees = getTrees("dolores")
	dolores._dialogueTree = trees[0]
	dolores._responseTree = trees[1]
	dolores._artPath = "res://Assets/Sprites/DolorsSplash.png"
	dolores.rect_position.x -= 150
	_characters.append(dolores)
	add_child(dolores)

"""
/*
* @pre Called once to begin main gameplay loop
* @post openSequence is called, then dialogue exchange begins for all 
   characters (this may need to be moved to _process so we can do one character at a time)
* @param None
* @return None
*/
"""		
func playGame():
	openSequence()
	_currentCharID = 0
	for id in range(0, len(_characters)):
		slideCharacter("left", id)
		playDialogue("d1a")

"""
/*
* @pre Called once to set stage for gameplay
* @post Opening exposition is played cinematic-style
* @param None
* @return None
*/
"""		
func openSequence():
	pass

"""
/*
* @pre Character sprite must be positioned just offscreen
* @post Moves a character sprite from onto screen from offscreen left or right
* @param direction: string indicating sprite is set to come from either left or right
* @param characterID: int indicating which character's sprite needs to be moved onto the screen
* @return None
*/
"""			
func slideCharacter(direction:String, characterID:int):
	var tween = get_tree().create_tween()	
	if direction == "left":
		tween.tween_property(_characters[characterID], "rect_position", Vector2(0,0), 0.75)
	elif direction == "right":
		tween.tween_property(_characters[characterID], "rect_position", Vector2(1850,0), 0.75)


"""
/*
* @pre Called whenever dialogue is supplied by the character identified with _currentCharID
* @post Dialogue is displayed, responses are made available to 
	player, actions ensuing from dialogue are carried out
* @param dialogueKey: dictionary identifier indicating which dialogue has been supplied
* @return None
*/
"""	
func playDialogue(dialogueKey):
	var dialogueContainer = _characters[_currentCharID]._dialogueTree[dialogueKey]
	var dialogueString = dialogueContainer[0]
	var responseKeys = dialogueContainer[1]
	var actionKeys = dialogueContainer[2]
	$textBox.queue_text(dialogueString)
	for key in responseKeys:
		pass
	for key in actionKeys:
		playAction(key)

"""
/*
* @pre Called whenever dialogue or responses have an associated action
* @post Action is carried out 
* @param actionKey: identifier indicating which action should be carried out
* @return None
*/
"""		
func playAction(actionKey):
	pass

"""
/*
* @pre Called once during character initialization
* @post None
* @param character: the name of the character for whom the dialogue trees should be loaded
* @return list of two constructed dictionaries: dialogueDict, which contains all dialogue
	 for the character, and responseDict, which contains all player responses.
*/
"""			
func getTrees(character:String):
	var dialogueDict = {}
	var responseDict = {}
	if character == "dolores":
		dialogueDict["d1a"] = ["I don't know what you think you're going to get out of me. I already told you, I never met the guy.", ["r1a", "r1b", "r1c"], []]
		responseDict["r1a"] = ["Wait, what? Where I am?", "d2a", []]
		responseDict["r1a"] = ["What guy?", "d2b", []]
		responseDict["r1c"] = ["Why don't you go ahead and tell it again.", "d2c", []]
	return [dialogueDict, responseDict]

func _recenter_buttons(width:int):
	$ButtonLayer/DecisionButtons.rect_position.x = get_viewport_rect().size.x / 2 - (width/2)

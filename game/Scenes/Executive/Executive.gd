extends Control

onready var _buttons = $ButtonLayer/DecisionButtons
onready var decisionButtons = $ButtonLayer/DecisionButtons
onready var _pendingDialogueKey = null

var _characters = []
var _currentCharID:int
var exposureLevel:int

var fade_in = true
onready var blink = $Blink/AnimationPlayer
onready var canvasVis = $Blink
onready var bg_music = $bg



# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	decisionButtons.connect("recenter_buttons", self, "_recenter_buttons")
	GlobalSignals.connect("textbox_empty", self, "_playPendingDialogue")
	init_bg()
	init_button()
	initializeCharacters()
	playBlink()
	playGame()

func _process(delta):
	if fade_in:
		bg_music.volume_db += 30*delta
		if bg_music.volume_db >= -10:
			fade_in = false
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
	dolores._charColor = "blue"
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
	playBlink()
	_currentCharID = 0
	for id in range(0, len(_characters)):
		slideCharacter("left", id)
		playDialogue("d1a")

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
	decisionButtons.buttonVisibility(false)
	var dialogueContainer = _characters[_currentCharID]._dialogueTree[dialogueKey]
	var dialogueString = dialogueContainer[0]
	var responseKeys = dialogueContainer[1]
	var actionKeys = dialogueContainer[2]
	if len(dialogueString) > 60:
		decisionButtons.changeButtonWidths(2)
	$textBox.queue_text(dialogueString, _characters[_currentCharID]._charName, _characters[_currentCharID]._charColor)
	decisionButtons._responseKeys = []
	decisionButtons._responseStrings = []
	for key in responseKeys:
		loadResponse(key)
	for key in actionKeys:
		playAction(key)
		
func loadResponse(responseKey):
	decisionButtons._responseKeys.append(responseKey)
	var responseContainer = _characters[_currentCharID]._responseTree[responseKey]
	var responseString = responseContainer[0]
	decisionButtons._responseStrings.append(responseString)
	
func playResponse(responseKey):
	var responseContainer = _characters[_currentCharID]._responseTree[responseKey]
	var responseString = responseContainer[0]
	var dialogueKey = responseContainer[1]
	var actionKeys = responseContainer[2]
	$textBox.queue_text(responseString, "Me", "red")
	for key in actionKeys:
		playAction(key)
	_pendingDialogueKey = dialogueKey
	
"""
/*
* @pre Called whenever dialogue or responses have an associated action
* @post Action is carried out 
* @param actionKey: identifier indicating which action should be carried out
* @return None
*/
"""		
func playAction(actionKey):
	if actionKey == "midExposure":
		raiseExposure(5)
	if actionKey == "highExposure":
		raiseExposure(10)
		
func raiseExposure(level:int):
	exposureLevel += level
	if exposureLevel > 30:
		print("You died!")

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
		responseDict["r1a"] = ["Wait, what? Where am I?", "d2a", ["highExposure"]]
		responseDict["r1b"] = ["What guy?", "d2b", ["midExposure"]]
		responseDict["r1c"] = ["Why don't you go ahead and tell it again.", "d2c", []]
		dialogueDict["d2a"] = ["Hello? What do you mean? You said you were a detective?", ["r2a", "r2b"], []]
		dialogueDict["d2b"] = ["The murder victim. I told you I'd never met him before tonight. Why are you interrogating me?", ["r2c", "r2d"], []]
		dialogueDict["d2c"] = ["Ugh. You could just take notes, you know. But fine. I thought he seemed a rather boring fellow. Going on and on about Nascar, or whatever those racecars are they have in Europe. You must have thought so too. Then the lights went out, and I heard that awful shriek. I screamed too, you know. And when the lights came back on I was still seated exactly where I had been. This same seat. Did I miss anything?", ["r2e", "r2f"], []]
		responseDict["r2a"] = ["I'm not a detective. Where the hell am I? Is that the moon out the window?", "d3a", ["highExposure"]]
		responseDict["r2b"] = ["I mean from your perspective, where am I? What does this place mean to you? Why are you here?", "d3b", []]
		responseDict["r2c"] = ["But you might have seen something.", "d3c", ["midExposure"]]
		responseDict["r2d"] = ["Well, what were your first impressions of him?", "d3d", []]
		dialogueDict["d3a"] = ["What are you talking about? We were enjoying a nice dinner together, you know, polite chit-chat before our host arrived, nothing serious, when suddenly Mr. ... Martin here was STABBED. Is this ringing a bell? Are you suffering from shock?", ["0"], []]
		dialogueDict["d3b"] = ["Well ... it's the home of my ... associate. Mr. Franklin Devino Rotwell. He invited me to this gorgeous mansion of his to discuss a business proposition. When I arrived I found several strangers: you, Mr. Arcwright, and Mr. ... Martin, God rest his soul waiting. It was to be a joint proposition, was my thinking. Now I don't know what to think.", ["0"], []]
		dialogueDict["d3c"] = ["It was pitch black. Do you mistake me for a rabbit?", ["0"], []]
		dialogueDict["d3d"] = ["I thought he seemed a rather boring fellow. Going on and on about Nascar, or whatever those racecars are they have in Europe. Still, he hardly deserved to be STABBED for that! He seemed a nice enough guy.", ["0"], []]
		dialogueDict["0"] = ["END OF DIALOGUE REACHED", ["0"], []]
		responseDict["0"] = ["END OF RESPONSES REACHED", "0", []]
	return [dialogueDict, responseDict]

func _recenter_buttons(width:int):
	decisionButtons.rect_position.x = get_viewport_rect().size.x / 2 - (width/2)

func _playPendingDialogue():
	if _pendingDialogueKey != null:
		var key = _pendingDialogueKey
		_pendingDialogueKey = null
		playDialogue(key)

"""
/*
* @pre Called during ready function
* @post None
* @param None
* @return None
* Plays blink anim
*/
"""	
func playBlink():
	canvasVis.visible = true
	blink.play("Blink")
	yield(blink, "animation_finished")
	canvasVis.visible = false

"""
/*
* @pre Called during ready function
* @post BG playing
* @param None
* @return None
* Initializes the background music
*/
"""	
func init_bg():
	bg_music.volume_db = -60
	bg_music.play()

"""
/*
* @pre Called during ready function
* @post buttons added to group "my_buttons"
* @param None
* @return None
* Initializes the background music
*/
"""	
func init_button():
	for button in get_tree().get_nodes_in_group("my_buttons"):
		button.connect("mouse_entered", self, "_mouse_button_entered")
		button.connect("focus_entered", self, "_mouse_button_entered")
		button.connect("button_down", self, "_button_down")
		
		
func _mouse_button_entered():
	$click.play()
func _button_down():
	$button_down.play()


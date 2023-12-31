extends Control

onready var _buttons = $ButtonLayer/DecisionButtons
onready var decisionButtons = $ButtonLayer/DecisionButtons
onready var _pendingDialogueKey = null

var _characters = []
var _currentCharID:int
var _current_char_speaking: String = ""
var dpos
var fpos

var d_is_speak = false
var f_is_speak = false
var fade_in = true
onready var blink = $Blink/AnimationPlayer
onready var canvasVis = $Blink
onready var bg_music = $bg

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	# warning-ignore:return_value_discarded
	decisionButtons.connect("recenter_buttons", self, "_recenter_buttons")
	# warning-ignore:return_value_discarded
	GlobalSignals.connect("textbox_empty", self, "_playPendingDialogue")
	# warning-ignore:return_value_discarded
	GlobalSignals.connect("currentSpeaker", self, "_currentSpeaker")
	$ButtonLayer/DecisionButtons.buttonVisibility(false)
	init_bg()
	init_button()
	initializeCharacters()
	playBlink() #will go to playGame() after animation ends

func _process(delta):
	if fade_in:
		bg_music.volume_db += 30*delta
		if bg_music.volume_db >= -10:
			fade_in = false
	if _current_char_speaking == "dolores":
		if dpos.self_modulate.a < 1:
			dpos.self_modulate.a += .75*delta
			dpos.scale.x += .05*delta
			dpos.scale.y += .05*delta
	else:
		if dpos.self_modulate.a >.5:
			dpos.self_modulate.a -= .75*delta
			dpos.scale.x -= .05*delta
			dpos.scale.y -= .05*delta
	if _current_char_speaking == "fred":
		if fpos.self_modulate.a < 1:
			fpos.self_modulate.a += .75*delta
			fpos.scale.x += .05*delta
			fpos.scale.y += .05*delta
	else:
		if fpos.self_modulate.a >.5:
			fpos.self_modulate.a -= .75*delta
			fpos.scale.x -= .05*delta
			fpos.scale.y -= .05*delta
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
	var fred = load("res://Scenes/Character/Character.tscn").instance()
	dolores._charName = "dolores"
	dolores._charColor = "blue"
	dolores._charID = 0
	fred._charName = "fred"
	fred._charColor = "red"
	fred._charID = 1
	var trees = getTrees("dolores")
	dolores._dialogueTree = trees[0]
	dolores._responseTree = trees[1]
	
	var trees2 = getTrees("fred")
	fred._dialogueTree = trees2[0]
	fred._responseTree = trees2[1]

	_characters.append(dolores)
	_characters.append(fred)

	$ButtonLayer.add_child(dolores)
	$ButtonLayer.add_child(fred)
	dpos = dolores.get_node("CanvasLayer").get_node("woman")
	dolores.get_node("CanvasLayer").get_node("man").visible = false
	fpos = fred.get_node("CanvasLayer").get_node("man")
	fred.get_node("CanvasLayer").get_node("woman").visible = false
	dpos.frame = 0
	fpos.frame = 0
	dpos.position = Vector2(-500,650)
	fpos.position = Vector2(2400,600)
	


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
	set_process(true)
	_currentCharID = 0
	slideCharacter("dolores")
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
func slideCharacter(character: String):
	if character == "dolores":
		var tween := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		# warning-ignore:return_value_discarded
		tween.tween_property(dpos, "position", Vector2(300,650), 5)
	elif character == "fred":
		var tween2 := create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		# warning-ignore:return_value_discarded
		tween2.tween_property(fpos, "position", Vector2(1600,600), 5)

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
	$textBox.queue_text(dialogueString, _characters[_currentCharID]._charName, _characters[_currentCharID]._charColor)
	$textBox.is_dialogue = true
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
	$textBox.queue_text(responseString, Global.getPlayerName(), "orange")
	$textBox.is_dialogue = false
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
	elif actionKey == "highExposure":
		raiseExposure(10)
	elif actionKey == "nextChar":
		_currentCharID = 1
		slideCharacter("fred")
		playDialogue("d1a")
	elif actionKey == "goodEnding":
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/goodEnding/goodEnding.tscn")
	elif actionKey == "inconclusive":
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/InconclusiveEnding/InconclusiveEnd.tscn")

func raiseExposure(level:int):
	$ButtonLayer/AwareMeter.updateExposure(level)

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
		
		responseDict["r2a"] = ["I'm not a detective. Is that the MOON out the window?", "d3a", ["highExposure"]]
		responseDict["r2b"] = ["I mean, what does this place mean to you? Why are you here?", "d3b", []]
		responseDict["r2c"] = ["But you might have seen something.", "d3c", ["midExposure"]]
		responseDict["r2d"] = ["Well, what were your first impressions of him?", "d3d", []]
		responseDict["r2e"] = ["And nothing stands out to you about today, besides the murder?", "d3e", ["midExposure"]]
		responseDict["r2f"] = ["No, that all checks out, thanks. Is someone else there?", "d1a", ["nextChar"]]
		
		dialogueDict["d3a"] = ["What are you talking about? We were enjoying a nice dinner together, you know, polite chit-chat before our host arrived, nothing serious, when suddenly Mr. ... Martin here was STABBED. Is this ringing a bell? Are you suffering from shock?", ["r3a", "r3b"], []]
		dialogueDict["d3b"] = ["Well ... it's the home of my ... associate. Mr. Franklin Devino Rotwell. He invited me to this gorgeous mansion of his to discuss a business proposition. When I arrived I found several strangers: you, Mr. Arcwright, and Mr. ... Martin, God rest his soul waiting. It was to be a joint proposition, was my thinking. Now I don't know what to think.", ["r3c", "r3d"], []]
		dialogueDict["d3c"] = ["It was pitch black. Do you mistake me for a rabbit?", ["r3b", "r3d", "r3e"], []]
		dialogueDict["d3d"] = ["I thought he seemed a rather boring fellow. Going on and on about Nascar, or whatever those racecars are they have in Europe. Still, he hardly deserved to be STABBED for that! He seemed a nice enough guy.", ["r3b", "r3e"], []]
		dialogueDict["d3e"] = ["BESIDES the murder? No, I dare say I expected nothing from today but a pleasant and potentially rewarding evening.", ["r3g"], []]
		
		responseDict["r3a"] = ["Forgive me. Yes, I had some questions for you. Did you see anything?", "d3c", []]
		responseDict["r3b"] = ["What does the room we're in look like to you?", "d4a", ["highExposure"]]
		responseDict["r3c"] = ["Just because of the murder? Or is there something besides that?", "d3e", ["midExposure"]]
		responseDict["r3d"] = ["What were your first impressions of Mr. Martin?", "d3d", []]
		responseDict["r3e"] = ["And nothing stands out to you about today, besides the murder?", "d3e", ["midExposure"]]
		responseDict["r3f"] = ["Oh really that's nice. Wait who else is there?", "d1a", ["nextChar"]]
		responseDict["r3g"] = ["No, that all checks out, thanks. Is someone else there?", "d1a", ["nextChar"]]
			
		dialogueDict["d4a"] = ["Well, it speaks of rather rich tastes, doesn't it? Oh, but I do love the color everywhere. To have the time to cultivate such plants as these in the comfort of your own home. Though I'm sure Mr. Rotwell has servants for that. I would kill for this mahogany floor of his, even if I had to scrub it myself. And don't even get me started on the view. I've always wanted to live by the coast.", ["r3f"], []]
		
		dialogueDict["0"] = ["END OF DIALOGUE REACHED", ["0"], ["inconclusive"]]
		responseDict["0"] = ["END OF RESPONSES REACHED", "0", ["inconclusive"]]
	elif character == "fred":
		dialogueDict["d1a"] = ["Interesting night we're having, eh?", ["r1a", "r1b", "r1c"], []]
		
		responseDict["r1a"] = ["Just another day in high society, in my view.", "d2a", []]
		responseDict["r1b"] = ["More interesting than I've seen, even as a detective.", "d2b", ["midExposure"]]
		responseDict["r1c"] = ["There's something here some of us aren't seeing. Is that right?", "d2c", ["highExposure"]]
		
		dialogueDict["d2a"] = ["Well, you're welcome to your opinion. It's all business at the end of the day. At least until someone gets murdered. I find it interesting that you're here at all detective. Then again, this whole situation is ... interesting. After all, regardless of whether one of us three is guilty ... somebody has to have pulled the lights.", ["0"], ["inconclusive"]]
		dialogueDict["d2b"] = ["Well detective, what's your diagnosis?", ["r2b"], []]
		dialogueDict["d2c"] = ["I do believe you're onto something. What's your diagnosis?", ["r2b"], []]
		
		responseDict["r2b"] = ["I think that we should finish our dinner. Forget the murder. And go home. If we can find our way.", "d2a", ["goodEnding"]]
		
		dialogueDict["0"] = ["END OF DIALOGUE REACHED", ["0"], ["inconclusive"]]
		responseDict["0"] = ["END OF RESPONSES REACHED", "0", ["inconclusive"]]
	return [dialogueDict, responseDict]

func _recenter_buttons(width:int):
	# warning-ignore:integer_division
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

func _currentSpeaker(current: String):
	if current == "dolores" || current == "fred" || current == Global.getPlayerName():
		_current_char_speaking = current
		if _current_char_speaking == "dolores":
			dpos.play()
		else:
			dpos.stop()
			dpos.frame = 0
		if _current_char_speaking == "fred":
			fpos.play()
		else:
			fpos.stop()
			fpos.frame = 0


func _on_AnimationPlayer_animation_finished(_anim_name):
	playGame()

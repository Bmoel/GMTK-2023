extends Control

var _characters = []

# Called when the node enters the scene tree for the first time.
func _ready():
	initializeCharacters()
	playGame()
	
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
	
func playGame():
	openSequence()
	for id in range(0, len(_characters)):
		slideCharacter("left", id)
		playDialogue(id)

func openSequence():
	pass
	
func slideCharacter(direction:String, characterID:int):
	var tween = get_tree().create_tween()	
	if direction == "left":
		tween.tween_property(_characters[characterID], "rect_position", Vector2(0,0), 0.75)
	elif direction == "right":
		tween.tween_property(_characters[characterID], "rect_position", Vector2(1850,0), 0.75)


func playDialogue(character):
	pass
	
func getTrees(character:String):
	var dialogueDict = {}
	var responseDict = {}
	if character == "dolores":
		dialogueDict["d1a"] = ["I don't know what you think you're going to get out of me. I already told you, I never met the guy.", ["r1a", "r1b", "r1c"], []]
		responseDict["r1a"] = ["Wait, what? Where I am?", "d2a", []]
		responseDict["r1a"] = ["What guy?", "d2b", []]
		responseDict["r1c"] = ["Why don't you go ahead and tell it again.", "d2c", []]
	return [dialogueDict, responseDict]

extends Control


var _charName
var _charColor
var _charID
var _dialogueTree
var _responseTree
var _artPath


# Called when the node enters the scene tree for the first time.
func _ready():
	$Splash.texture = load(_artPath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

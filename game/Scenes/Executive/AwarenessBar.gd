extends Sprite

var path = "res://Assets/Meter"
var offenses = 0
var words:Dictionary = {
	0: "Blank.png",
	1: "One.png",
	2: "Two.png",
	3: "Three.png",
	4: "Four.png",
	5: "Five.png"
}

func updateAwareness():
	offenses += 1
	if offenses > 5:
		print('TODO: IMPLEMENT GAME OVER IN AwarenessBar.gd')
		return
	texture = load(path + words.get(offenses))

extends Sprite

var path = "res://Assets/Meter"
var total_level = 0
var words:Dictionary = {
	0: "Blank.png",
	1: "One.png",
	2: "Two.png",
	3: "Three.png",
	4: "Four.png",
	5: "Five.png"
}

func updateExposure(value: int):
	total_level += value
	if total_level >= 30:
		get_tree().change_scene("res://Scenes/badEnding/badEnd.tscn")
		return
	var offenses = int(total_level / 5)
	texture = load(path + words.get(offenses))

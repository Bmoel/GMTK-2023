extends Node

const COLORS:Dictionary = {
	"blue": "#2245d4",
	"red": "#c72820",
	"green": "#1eba1e",
	"orange": "#f5ab18",
	"pink": "#d422b6",
	"white": "#ffffff",
	"black": "#000000"
}

func getColorCode(color:String):
	var code = COLORS.get(color.to_lower())
	if code == null:
		return COLORS.get("white")
	return code

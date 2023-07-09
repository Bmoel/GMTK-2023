extends Node

#GLOBAL VOLUME
var masterVol:int = 0
var musicVol:int = 0
var sfxVol:int = 0

var player_name = ""

const COLORS:Dictionary = {
	"blue": "#2245d4",
	"red": "#c72820",
	"green": "#1eba1e",
	"orange": "#f5ab18",
	"pink": "#d422b6",
	"white": "#ffffff",
	"black": "#000000"
}

func getColorCode(color:String) -> String:
	var code = COLORS.get(color.to_lower())
	if code == null:
		return COLORS.get("white")
	return code

func setPlayerName(value: String) -> void:
	player_name = value.strip_edges()

func getPlayerName() -> String:
	return player_name

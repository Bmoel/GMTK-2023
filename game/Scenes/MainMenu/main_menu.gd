extends Node2D

onready var bg_music = $mainmenu

var _credits_scene = preload("res://Scenes/Credits/Credits.tscn")
var _options_scene = preload("res://Scenes/Options/Options.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	GlobalSignals.connect("unselect_credits_button", self, "_credits_focus")
	bg_music.play()
	$CanvasLayer/VBoxContainer/Start.grab_focus()
	for button in get_tree().get_nodes_in_group("menu_buttons"):
		button.connect("mouse_entered", self, "_mouse_button_entered")
		button.connect("focus_entered", self, "_mouse_button_entered")
		button.connect("button_down", self, "_button_down")

func _on_Start_pressed():
	bg_music.stop()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/openingScene/openingScene.tscn")

func _on_Options_pressed():
	var new_opt:Popup = _options_scene.instance()
	$CanvasLayer.add_child(new_opt)
	new_opt.popup_centered()

func _on_Credits_pressed():
	var new_credits:Popup = _credits_scene.instance()
	$CanvasLayer.add_child(new_credits)
	new_credits.popup_centered()

func _on_Exit_pressed():
	get_tree().quit()

func _credits_focus(value:bool) -> void:
	if value:
		$CanvasLayer/VBoxContainer/Credits.grab_focus()
	else:
		$CanvasLayer/VBoxContainer/Credits.release_focus()

func _mouse_button_entered():
	$click.play()

func _button_down():
	$button_down.play()

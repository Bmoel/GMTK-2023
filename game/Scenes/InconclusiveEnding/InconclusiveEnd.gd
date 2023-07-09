extends Node2D

onready var textbox = $textBox

var dialogue = [
	"Your dialogue choices did not result in anything bad, but nothing good either",
	"The good ending may require further investigation",
]

func _ready():
	GlobalSignals.connect("textbox_empty", self, "_update_textbox")
	textbox.queue_text(dialogue[0], Global.getPlayerName(), "green")
	dialogue.pop_front()

func _update_textbox():
	if len(dialogue) != 0:
		textbox.queue_text(dialogue[0], Global.getPlayerName(), "green")
		dialogue.pop_front()
	else:
		$InconclusiveEnd.show()
		$VBoxContainer.show()
		$VBoxContainer/MainMenu.grab_focus()

func _on_MainMenu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu/main_menu.tscn")

func _on_Exit_pressed():
	get_tree().quit()

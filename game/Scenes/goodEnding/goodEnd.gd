extends Node2D

onready var textbox = $textBox

var dialogue = [
	"You wake up the next morning with no memory of the previous night's experience, except for in a vague notion of having narrowly avoided a grisly fate.",
	"As you look towards the ceiling you can't help but wonder just what happened the night before",
	"But hey, must not be important if I can't remember",
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
		$GoodEnd.show()
		$VBoxContainer.show()
		$VBoxContainer/MainMenu.grab_focus()

func _on_MainMenu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu/main_menu.tscn")

func _on_Exit_pressed():
	get_tree().quit()

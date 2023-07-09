extends Node2D

onready var textbox = $textBox

var dialogue = [
	"The aliens have detected your awareness of the dinner party simulation. They extinguish your life as they did Mr. Martin's",
	"Your moves throughout the game have been suboptimal, maybe a different approach is required",
	"But for now, your time in here has come to a close",
	"Good luck out there"
]

func _ready():
	GlobalSignals.connect("textbox_empty", self, "_update_textbox")
	textbox.queue_text(dialogue[0], "THE COUNCIL", "red")
	dialogue.pop_front()

func _update_textbox():
	if len(dialogue) != 0:
		textbox.queue_text(dialogue[0], "THE COUNCIL", "red")
		dialogue.pop_front()
	else:
		$GameOver.show()
		$VBoxContainer.show()
		$VBoxContainer/MainMenu.grab_focus()

func _on_MainMenu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu/main_menu.tscn")

func _on_Exit_pressed():
	get_tree().quit()

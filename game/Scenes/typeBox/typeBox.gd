extends CanvasLayer

onready var text_input = $BackContainer/MarginContainer/HBoxContainer/TextInput
onready var instructions_label = $Instructions/Label

func _ready():
	instructions_label.text = "Type your answer"
	text_input.wrap_enabled = true
	text_input.grab_focus()
	

func _input(event):
	if event.is_action_pressed("ui_accept"):
		pass

extends CanvasLayer

onready var text_input = $BackContainer/MarginContainer/HBoxContainer/TextInput
onready var _topBox = $TopBox/Label

#Called on object declartation
func _ready() -> void:
	text_input.wrap_enabled = true
	text_input.grab_focus()

#Called whenever keyboard/mouse event happens
func _input(event) -> void:
	var stripped_name = text_input.text.strip_edges()
	var can_submit:bool = (text_input.text.strip_edges() != "")
	if len(stripped_name) > 20:
		set_topBox("Name too long", "blue")
		return
	elif len(stripped_name) > 0:
		set_topBox("Enter to submit", "blue")
	else:
		set_topBox("What's your name?", "blue")
	if event.is_action_pressed("Enter") and can_submit:
		GlobalSignals.emit_signal("typebox_submit",text_input.text)
		queue_free()

#Function to extend or decrease size of instruction header
func set_instructions_length(x_length:int):
	$Instructions.rect_size.x = x_length

#Function to set text of instruction header
func set_topBox(text_in:String, color: String):
	var color_code = Global.getColorCode(color)
	var myText = " [color=" + color_code + "]" + text_in + "[/color]"
	_topBox.bbcode_text = myText

extends CanvasLayer

onready var text_input = $BackContainer/MarginContainer/HBoxContainer/TextInput
onready var _topBox = $TopBox/Label

#Called on object declartation
func _ready() -> void:
	text_input.wrap_enabled = true
	text_input.grab_focus()

#Called whenever keyboard/mouse event happens
func _input(event) -> void:
	var can_submit:bool = (text_input.text.strip_edges() != "")
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

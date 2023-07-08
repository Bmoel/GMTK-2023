extends VBoxContainer

var _buttons:Array = [] #holds all button objects

func _ready() -> void:
	#Add all objects to _buttons array
	for button_obj in get_children():
		_buttons.append(button_obj)
	changeButtonTexts(["1","2","3","4"])

#Changes all internal texts of buttons
#NOTE: IF WANT TO KEEP SAME TEXT AS BEFORE, USE ""
func changeButtonTexts(texts:Array) -> void:
	if len(texts) != 4:
		print("ERROR: NEED TO INPUT ARRAY WITH 4 PARAMETERS")
		print("FUNCTION -> changeButtonTexts in DecisionButtons.gd")
		return
	var inc = 0
	for b_obj in _buttons:
		b_obj.text = texts[inc]
		inc += 1

#Hide button you want
#NOTE: You enter 1-4, it will subtract 1 for you
func hide_button(button_num: int) -> void:
	button_num -= 1
	if button_num < 0 or button_num > 3:
		print("ERROR: invalid button number")
		return
	_buttons[button_num].hide()

#Show button you want
#NOTE: You enter 1-4, it will subtract 1 for you
func show_button(button_num: int):
	button_num -= 1
	if button_num < 0 or button_num > 3:
		print("ERROR: invalid button number")
		return
	_buttons[button_num].show()

#Button 1 pressed
func _on_b1_pressed() -> void:
	pass # Replace with function body.

#Button 2 pressed
func _on_b2_pressed() -> void:
	pass # Replace with function body.

#Button 3 pressed
func _on_b3_pressed() -> void:
	pass # Replace with function body.

#Button 4 pressed
func _on_b4_pressed() -> void:
	pass # Replace with function body.

extends VBoxContainer

signal recenter_buttons(width)

var _buttons:Array = [] #holds all button objects
var _responseKeys:Array = []
var _responseStrings:Array = []

func _ready() -> void:
	#Add all objects to _buttons array
	for button_obj in get_children():
		_buttons.append(button_obj)
	changeButtonTexts(["1","2","3","4"])
	GlobalSignals.connect("hide_buttons", self, "_updateButtons")

func _updateButtons(value) -> void:
	buttonVisibility(value)
	if value:
		var numButtons = len(_responseStrings)
		var newTexts = []
		for i in range(0, numButtons):
			var responseString = _responseStrings[i]
			newTexts.append(responseString)
		for i in range(numButtons + 1, 5):
			newTexts.append("")
			hide_button(i)
		changeButtonTexts(newTexts)

#Changes all internal texts of buttons
#NOTE: IF WANT TO KEEP SAME TEXT AS BEFORE, USE ""
func changeButtonTexts(texts:Array) -> void:
	if len(texts) != 4:
		print("ERROR: NEED TO INPUT ARRAY WITH 4 PARAMETERS")
		print("FUNCTION -> changeButtonTexts in DecisionButtons.gd")
		return
	var inc = 0
	for b_obj in _buttons:
		if texts[inc] == "":
			hide_button(inc+1)
			continue
		b_obj.text = texts[inc]
		inc += 1

#Changes the widths of ALL buttons
#recentered back inside of Executive.gd
func changeButtonWidths(width: int):
	rect_size.x = width
	emit_signal("recenter_buttons", width)

#Function to show/hide ALL buttons
# true = show all, false = hide all
func buttonVisibility(value: bool):
	visible = value
	for i in range(1,5):
		if value:
			show_button(i)
		else:
			hide_button(i)

#Hide button you want INDIVIDUALLY
#NOTE: You enter 1-4, it will subtract 1 for you
func hide_button(button_num: int) -> void:
	button_num -= 1
	if button_num < 0 or button_num > 3:
		print("ERROR: invalid button number")
		return
	_buttons[button_num].hide()

#Show button you want INDIVIDUALLY
#NOTE: You enter 1-4, it will subtract 1 for you
func show_button(button_num: int):
	button_num -= 1
	if button_num < 0 or button_num > 3:
		print("ERROR: invalid button number")
		return
	_buttons[button_num].show()

#Button 1 pressed
func _on_b1_pressed() -> void:
	var executive = get_parent().get_parent()
	if not executive.get_node("textBox")._blockingInput:
		buttonVisibility(false)
		var responseKey = _responseKeys[0]
		executive.playResponse(responseKey)

#Button 2 pressed
func _on_b2_pressed() -> void:
	var executive = get_parent().get_parent()
	if not executive.get_node("textBox")._blockingInput:
		buttonVisibility(false)
		var responseKey = _responseKeys[1]
		executive.playResponse(responseKey)

#Button 3 pressed
func _on_b3_pressed() -> void:
	var executive = get_parent().get_parent()
	if not executive.get_node("textBox")._blockingInput:
		buttonVisibility(false)
		var responseKey = _responseKeys[2]
		executive.playResponse(responseKey)

#Button 4 pressed
func _on_b4_pressed() -> void:
	var executive = get_parent().get_parent()
	if not executive.get_node("textBox")._blockingInput:
		buttonVisibility(false)
		var responseKey = _responseKeys[3]
		executive.playResponse(responseKey)

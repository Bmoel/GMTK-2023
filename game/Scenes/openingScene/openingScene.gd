extends Popup

signal openingDone()

onready var textbox = $textBox
onready var typebox = $typeBox
onready var colorRect = $ColorRect

var dialogue_text:Array = ["...","...","...","...","??????????"]
var dialogue_inc = 0

func _ready():
	typebox.show()
	GlobalSignals.connect("typebox_submit", self, "_start_dialogue")
	typebox.set_topBox("What's your name?", "blue")
	

func _start_dialogue(nameGiven:String):
	Global.setPlayerName(nameGiven)
	typebox.queue_free()
	textbox.show()
	GlobalSignals.connect("textbox_shift", self, "_textbox_shift")
	GlobalSignals.connect("textbox_empty", self, "_textbox_empty")
	textbox.queue_text(dialogue_text[dialogue_inc])

func _textbox_shift(value):
	if (not value) and (dialogue_inc < 4):
		dialogue_inc += 1
		textbox.queue_text(dialogue_text[dialogue_inc])
	$ColorRect.modulate.a8 -= 5

func _textbox_empty():
	textbox.queue_free()
	emit_signal("openingDone")
	queue_free()

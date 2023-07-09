extends Node2D

signal openingDone()

onready var textbox = $textBox
onready var typebox = $typeBox
onready var colorRect = $ColorRect

var dialogue_inc = 0

func _ready():
	typebox.show()
	GlobalSignals.connect("textbox_shift", self, "_textbox_shift")
	GlobalSignals.connect("textbox_empty", self, "_textbox_empty")
	GlobalSignals.connect("typebox_submit", self, "_start_dialogue")
	typebox.set_topBox("What's your name?", "blue")

func _start_dialogue(nameGiven:String):
	Global.setPlayerName(nameGiven)
	textbox.queue_text("...")
	textbox.queue_text("...")
	textbox.queue_text("...")
	textbox.queue_text("...")
	textbox.queue_text("??????????")

func _textbox_shift(value):
	$ColorRect.modulate.a8 -= 5

func _textbox_empty():
	get_tree().change_scene("res://Scenes/Executive/Executive.tscn")

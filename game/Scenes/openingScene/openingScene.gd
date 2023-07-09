extends Node2D

onready var textbox = $textBox
onready var typebox = $typeBox
onready var colorRect = $ColorRect

var dialogue_inc = 0

func _ready():
	typebox.show()
	GlobalSignals.connect("textbox_empty", self, "_textbox_empty")
	GlobalSignals.connect("typebox_submit", self, "_start_dialogue")
	typebox.set_topBox("What's your name?", "blue")

func _start_dialogue(nameGiven:String):
	Global.setPlayerName(nameGiven)
	nameGiven = Global.getPlayerName()
	textbox.queue_text("...", nameGiven, "orange")
	textbox.queue_text("...", nameGiven, "orange")
	textbox.queue_text("I remember now", nameGiven, "orange")
	textbox.queue_text("My whole life flashed right before my eyes, how did I forget?", nameGiven, "orange")
	textbox.queue_text("Nevermind that though, where am I?", nameGiven, "orange")
	textbox.queue_text("Last time I checked I was-", nameGiven, "orange")
	textbox.queue_text("AWAKENING SEQUENCE BEGINNING", "UNKNOWN ENTITY", "red")
	textbox.queue_text("Wait what stop!!??", nameGiven, "orange")
	textbox.queue_text("Hey, can you hear me?", "ANOTHER VOICE", "green")
	textbox.queue_text("What is happening...", nameGiven, "orange")
	textbox.queue_text("Please listen to me, I don't have much time but I need you to keep your identity a secret", "ANOTHER VOICE", "green")
	textbox.queue_text("But why should I have to do that, and who are you?", nameGiven, "orange")
	textbox.queue_text("Like I said there is no ti...      look ou...   careful...", "ANOTHER VOICE", "green")
	textbox.queue_text("AWAKENING SEQUENCE STARTING IN 3.. 2.. 1", "UNKNOWN ENTITY", "red")

func _textbox_empty():
	get_tree().change_scene("res://Scenes/Executive/Executive.tscn")

extends Node

"""
* Purpose - Send a signal when a textbox is displayed and goes away
* Used in - textBox.gd
* Parameter - value -> boolean (true if currently showing textbox, false if textbox is gone)
"""
# warning-ignore:unused_signal
signal textbox_shift(value)

"""
* Purpose - Send a signal when a textbox is empty
* Used in - textBox.gd
* Parameter - None
"""
# warning-ignore:unused_signal
signal textbox_empty()

"""
* Purpose - Send a signal when a typebox enters text
* Used in - typeBox.gd
* Parameter - text (text that user entered)
"""
# warning-ignore:unused_signal
signal typebox_submit(text)

"""
* Purpose: To let main menu whether to select button or not
* Used in: Credits.gd
* Params: value (boolean, true if to select)
"""
# warning-ignore:unused_signal
signal unselect_credits_button(value)

"""
* Purpose: To let exec know to not show buttons
* Used in: DecisionButtons.gd
* Params: value (boolean, true if to select)
"""
# warning-ignore:unused_signal
signal hide_buttons(value)

"""
* Purpose: To let exec know to not show buttons
* Used in: DecisionButtons.gd
* Params: value (boolean, true if to select)
"""
# warning-ignore:unused_signal
signal currentSpeaker(speaker)

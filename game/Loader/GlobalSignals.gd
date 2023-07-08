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

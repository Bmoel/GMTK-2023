#Citations:
#	Audio section based on tutorial from https://www.youtube.com/watch?v=cQkEPej_gRU

extends Popup

#CONSTANTS
const MIN_VOLUME = -20
const MASTER_VOLUME = 0 
const MUSIC_VOLUME = 1 
const SFX_VOLUME = 2 

onready var _masterSlider = $MarginContainer/GridContainer/MasterVolSlider
onready var _musicSlider = $MarginContainer/GridContainer/MusicVolSlider
onready var _sfxSlider = $MarginContainer/GridContainer/SFXVolSlider

func _ready():
	_masterSlider.value = Global.masterVol
	_musicSlider.value = Global.musicVol
	_sfxSlider.value = Global.sfxVol

"""
* Pre: Slider moved
* Post: Change master volume bus
* Params: value (value of slider)
* Return: None
"""
func _on_MasterVolSlider_value_changed(value) -> void:
	update_volume(MASTER_VOLUME,value)

"""
* Pre: Slider moved
* Post: Change master volume bus
* Params: value (value of slider)
* Return: None
"""
func _on_MusicVolSlider_value_changed(value):
	update_volume(MUSIC_VOLUME,value)

"""
* Pre: Slider moved
* Post: Change master volume bus
* Params: value (value of slider)
* Return: None
"""
func _on_SFXVolSlider_value_changed(value) -> void:
	update_volume(SFX_VOLUME,value)

"""
* Pre: one of the volume sliders was changed
* Post: Volume is changed depending on value
* Params: bus_idx (index of audio bus to change)
		  value (value of slider)
* Return: None
"""
func update_volume(bus_idx, value) -> void:
	var was_mute = false #variable to tell if volume was muted and needs to be changed
	###########################################################################
	#Set audio bus and save data to file
	AudioServer.set_bus_volume_db(bus_idx,value)
	if bus_idx == 0:
		if Global.masterVol == MIN_VOLUME:
			was_mute = true
		Global.masterVol = value
	elif bus_idx == 1:
		if Global.musicVol == MIN_VOLUME:
			was_mute = true
		Global.musicVol = value
	elif bus_idx == 2:
		if Global.sfxVol == MIN_VOLUME:
			was_mute = true
		Global.sfxVol = value
	###########################################################################
	# if the value is a min, mute the bus
	if value == MIN_VOLUME:
		AudioServer.set_bus_mute(bus_idx, not AudioServer.is_bus_mute(bus_idx))
	# if the previous value was a min and now isn't, unmute the bus
	if was_mute and value != MIN_VOLUME:
		AudioServer.set_bus_mute(bus_idx, false)

"""
* Pre: Popup is hidden
* Post: deletes the popup from memory
* Return: None
"""
func _on_Popup_popup_hide():
	queue_free()

class_name MainButton
extends TextureButton

signal main_button_pressed(type, index, toggled_on)

enum ButtonType {MAP, SHIELDS, ALARM}
@export var button_type: ButtonType
@export var on_message_address : String
@export var off_message_address : String

@onready var osc_client: OSCClient = $OSCClient
@onready var sfx_enable: AudioStreamPlayer = $SFXEnable
@onready var sfx_disable: AudioStreamPlayer = $SFXDisable


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		sfx_enable.play()
	else:
		sfx_disable.play()
	main_button_pressed.emit(button_type, self.get_index(), toggled_on)


func _on_pressed() -> void:
	osc_client.send_message(on_message_address, [1])
	sfx_enable.play()

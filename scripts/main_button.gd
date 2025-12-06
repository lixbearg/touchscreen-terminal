extends TextureButton

@export var on_message_address : String
@export var off_message_address : String

@onready var osc_client: OSCClient = $OSCClient

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		osc_client.send_message(on_message_address, [1])
		osc_client.send_message(off_message_address, [0])
	else:
		osc_client.send_message(on_message_address, [0])
		osc_client.send_message(off_message_address, [1])

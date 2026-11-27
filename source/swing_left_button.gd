extends Button

@export var keycode: Key = KEY_LEFT

func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _on_button_down() -> void:
	_send_key_event(true)

func _on_button_up() -> void:
	_send_key_event(false)

func _send_key_event(pressed_state: bool) -> void:
	var event := InputEventKey.new()
	event.keycode = keycode
	event.physical_keycode = keycode
	event.pressed = pressed_state
	Input.parse_input_event(event)

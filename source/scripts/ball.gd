extends RigidBody2D

var MAX_VELOCITY = 1000

var IS_RESET = false

signal restart()

func reset(state:PhysicsDirectBodyState2D):
	state.transform.origin = Vector2(640,550)
	state.linear_velocity = Vector2.ZERO
	state.angular_velocity = 0
	IS_RESET = false

func clamp_velocity(state:PhysicsDirectBodyState2D):
	var velocity = state.linear_velocity
	var speed = velocity.length()
	
	if speed > MAX_VELOCITY:
		state.linear_velocity = velocity.normalized() * MAX_VELOCITY

func _ready():
	var reset_button:Button = get_node("/root/Main/Whippet Port/LSD Port/Joint Port/Alcohol Port/Glow Port/Reset Button")
	
	reset_button.pressed.connect(_on_button_pressed)

func _integrate_forces(state):
	clamp_velocity(state)
	
	if state.transform.origin.y > 1000:
		emit_signal("restart")
	if IS_RESET:
		reset(state)


func _on_button_pressed():
	emit_signal("restart")


func _on_restart():
	IS_RESET = true

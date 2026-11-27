extends CharacterBody2D

var DASH_SPEED = 1100
var BASE_SPEED = 500

var speed
var moving_dir = 0

var tween:Tween

var IS_SWINGING = false

func reset():
	
	if tween: tween.kill()
	global_rotation = 0
	global_position = Vector2(640,650)
	velocity = Vector2.ZERO
	IS_SWINGING = false

func inputHandler(delta):
	if Input.is_key_pressed(KEY_A):
		movements["move"].call(delta, -1)
	if Input.is_key_pressed(KEY_D):
		movements["move"].call(delta, 1)
	
	if Input.is_key_pressed(KEY_RIGHT):
		if !IS_SWINGING: movements["swing"].call(1)
	if Input.is_key_pressed(KEY_LEFT):
		if !IS_SWINGING: movements["swing"].call(-1)
	if Input.is_key_pressed(KEY_UP):
		if !IS_SWINGING: movements["bump"].call()

var movements = {
	"move": func(delta, x):
		moving_dir = x
		if Input.is_key_pressed(KEY_SHIFT):
			speed = BASE_SPEED
		else:
			speed = DASH_SPEED
		var pos = position + Vector2(x,0) * speed * delta
		position.x = clamp(pos.x,150,1130),
	
	"swing": func(dir):
		IS_SWINGING = true
		tween = get_tree().create_tween()
		
		var pivot_point = position + Vector2(cos(rotation), sin(rotation)) * 75 * dir
		var offset = position - pivot_point
		var start_rot = rotation
		var end_angle = start_rot + 2 * dir
		
		tween.tween_method(func(a):
			pivot_point = position + Vector2(cos(rotation), sin(rotation)) * 75 * dir
			rotation = a
			position = pivot_point + offset.rotated(a - start_rot)
			, start_rot, end_angle, 0.4).set_trans(Tween.TRANS_LINEAR)
		
		tween.tween_method(func(a):
			pivot_point = position + Vector2(cos(rotation), sin(rotation)) * 75 * dir
			rotation = a
			position = pivot_point + offset.rotated(a - start_rot)
			, end_angle, 0, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
			
		tween.finished.connect(func():
			position.x = clamp(position.x,150,1130)
			IS_SWINGING = false),
			
	"bump": func():
		IS_SWINGING = true
		tween = get_tree().create_tween()
		
		var start_alt = position.y
		tween.tween_method(func(a):
			position.y = a
			, start_alt, start_alt-100, 0.3).set_trans(Tween.TRANS_LINEAR)
		tween.tween_method(func(a):
			position.y = a
			, start_alt-100, start_alt, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		
		tween.finished.connect(func(): IS_SWINGING = false)
}

func _physics_process(delta):
	inputHandler(delta)

func _on_restart() -> void:
	reset()

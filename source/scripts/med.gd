extends Area2D

@onready var score = get_node("/root/Main/Whippet Port/LSD Port/Joint Port/Alcohol Port/Glow Port/Score/Score")
@onready var timer = $Timer

var last_med = 0

signal drug_fix()

func _ready():
	self.hide()
	monitoring = false

func _process(_delta):
	if int(score.text) > 2 && (int(score.text) % 3 == 0 && last_med != int(score.text)):
		last_med = int(score.text)
		if !timer.is_stopped(): timer.stop()
		
		global_position = Vector2(randi_range(75,1205), randi_range(175,500))
		self.show()
		monitoring = true
		
		timer.start()
		await timer.timeout
		
		monitoring = false
		self.hide()

func _physics_process(_delta):
	if monitoring:
		var touched:Array = get_overlapping_bodies().map(func(b): return b.name)	
		if touched.has("Ball"):
			timer.timeout.emit()
			drug_fix.emit()

func _on_ball_restart():
	last_med = 0
	timer.timeout.emit()

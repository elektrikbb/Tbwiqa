extends Area2D

var IS_RELOCATING = false

@onready var SCORE = get_node("/root/Main/Whippet Port/LSD Port/Joint Port/Alcohol Port/Glow Port/Score")
var SPRITES:Array[Sprite2D]

enum Drugs {ALCOHOL, JOINT, LSD, WHIPPET}
var current_drug = 0
var score:Array[int] = [0,0,0,0]

signal use_drug(drug)

func score_reset():
	score = [0,0,0,0]
	for i in range(4):
		SCORE.get_node(Drugs.keys()[i]).text = "0"
	SCORE.get_node("Score").text = "Score: 0" 

func score_update():
	score[current_drug] += 1
	SCORE.get_node(Drugs.keys()[current_drug]).text = str(score[current_drug])
	SCORE.get_node("Score").text = "Score: " + str(score.reduce(func(acc, num): return acc + num, 0))

var do_drug = {
	"ALCOHOL": func():
		score_update()
		use_drug.emit("alcohol"),
	"JOINT": func():
		score_update()
		use_drug.emit("joint"),
	"LSD": func():
		score_update()
		use_drug.emit("lsd"),
	"WHIPPET": func():
		score_update()
		use_drug.emit("whippet"),
}

func hide_target():
	SPRITES[current_drug].hide()
	monitoring = false
	
func show_target():
	current_drug = randi_range(0,3)
	global_position = Vector2(randi_range(75,1205), randi_range(175,500))
	SPRITES[current_drug].show()
	monitoring = true

func relocate():
	IS_RELOCATING = true
	hide_target()
	
	do_drug[Drugs.keys()[current_drug]].call()
	await get_tree().create_timer(1).timeout
	
	show_target()
	IS_RELOCATING = false

func refresh_all_drugs():
	use_drug.emit("alcohol")
	use_drug.emit("joint")
	use_drug.emit("lsd")
	use_drug.emit("whippet")

func _ready():
	refresh_all_drugs()
	SPRITES.resize(4)
	for i in range(4):
		SPRITES[i] = get_node(Drugs.keys()[i])
	
	hide_target()
	show_target()

func _physics_process(_delta):
	if !IS_RELOCATING:
		var touched:Array = get_overlapping_bodies().map(func(b): return b.name)	
		if touched.has("Ball"):
			relocate()

func _on_ball_restart():
	score_reset()
	refresh_all_drugs()

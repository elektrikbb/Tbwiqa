extends TextureRect

@onready var drug = get_node("/root/Main/Whippet Port/LSD Port/Joint Port/Alcohol Port/Glow Port/Target")
var sh = load("res://shaders/lsd.gdshader")
var sm = ShaderMaterial.new()

var lsd_score = 0


func _ready():
	sm.shader = sh
	material = sm


func do_drug():
	sm.set_shader_parameter("strength", (1.0 / 10) *  lsd_score)
	sm.set_shader_parameter("speed", (2.0 / 10) *  lsd_score)
	sm.set_shader_parameter("alpha", (1.0 / 10) *  clamp(lsd_score, 0, 8))


func _on_med_drug_fix() -> void:
	lsd_score = 0
	do_drug()


func _on_target_use_drug(current_drug):
	if current_drug == "lsd":
		lsd_score = clamp(drug.score[2], 0, 10)
		do_drug()

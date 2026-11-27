extends TextureRect

@onready var drug = get_node("/root/Main/Whippet Port/LSD Port/Joint Port/Alcohol Port/Glow Port/Target")
var sh = load("res://shaders/whippet.gdshader")
var sm = ShaderMaterial.new()

var whippet_score = 0


func _ready():
	sm.shader = sh
	material = sm


func do_drug():	
	sm.set_shader_parameter("close_limit", 1 - ((1.0 / 10) *  whippet_score))


func _on_med_drug_fix() -> void:
	whippet_score = 0
	do_drug()


func _on_target_use_drug(current_drug):
	if current_drug == "whippet":
		whippet_score = clamp(drug.score[3], 0, 10)
		do_drug()

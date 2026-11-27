extends TextureRect

@onready var drug = get_node("/root/Main/Whippet Port/LSD Port/Joint Port/Alcohol Port/Glow Port/Target")
var sh = load("res://shaders/alcohol.gdshader")
var sm = ShaderMaterial.new()

var alcohol_score = 0


func _ready():
	sm.shader = sh
	material = sm


func do_drug():	
	sm.set_shader_parameter("amplitude", (1.0 / 10) *  alcohol_score)
	sm.set_shader_parameter("speed", (1.0 / 10) *  alcohol_score)


func _on_med_drug_fix() -> void:
	alcohol_score = 0
	do_drug()


func _on_target_use_drug(current_drug):
	if current_drug == "alcohol":
		alcohol_score = clamp(drug.score[0], 0, 10)
		do_drug()

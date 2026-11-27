extends TextureRect

@onready var drug = get_node("/root/Main/Whippet Port/LSD Port/Joint Port/Alcohol Port/Glow Port/Target")
var sh = load("res://shaders/joint.gdshader")
var sm = ShaderMaterial.new()

var joint_score = 0


func _ready():
	sm.shader = sh
	material = sm


func do_drug():
	sm.set_shader_parameter("chaos", (32.0 / 10) *  joint_score)
	sm.set_shader_parameter("attenuation", (5.0 / 10) *  joint_score)


func _on_med_drug_fix() -> void:
	joint_score = 0
	do_drug()


func _on_target_use_drug(current_drug):
	if current_drug == "joint":
		joint_score = clamp(drug.score[1], 0, 10)
		do_drug()

extends Camera2D

var targetPosition
var target

#인스펙터에 변수를 노출 시키기 위한 키워드
export(Color, RGB) var backgroundColor
export(float) var lerpFactor

func _ready():
	#Server for anything visible. The visual server is the API backend for everything visible. The whole scene system mounts on it to display.
	VisualServer.set_default_clear_color(backgroundColor)
	
	var targets = get_tree().get_nodes_in_group("player")
	if targets.size() > 0 : 
		target = targets[0];
	
func _process(delta):
	acquire_target_position()
	
	global_position = lerp(global_position, targetPosition, delta * lerpFactor)


func acquire_target_position() :
	targetPosition = target.global_position

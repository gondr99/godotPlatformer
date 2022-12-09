extends Camera2D

var targetPosition
var target: Node2D

#인스펙터에 변수를 노출 시키기 위한 키워드
export(Color, RGB) var backgroundColor
export(float) var lerpFactor

func _ready():
	#Server for anything visible. The visual server is the API backend for everything visible. The whole scene system mounts on it to display.
	VisualServer.set_default_clear_color(backgroundColor)
	find_player()
	
func _process(delta):
	acquire_target_position()

	global_position = lerp(global_position, targetPosition, delta * lerpFactor)


func acquire_target_position() :
	if is_instance_valid(target) == false :   #g
		find_player()
	targetPosition = target.global_position
	
#이건 내가 짠거야. 원래 코드는 process에서 계속 찾음
func find_player():
	var targets = get_tree().get_nodes_in_group("player")
	if targets.size() > 0 : 
		target = targets[0];

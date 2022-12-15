extends Camera2D

class_name MainCamera

var targetPosition
var target: Node2D

#인스펙터에 변수를 노출 시키기 위한 키워드
export(Color, RGB) var backgroundColor
export(float) var lerpFactor
export(OpenSimplexNoise) var shakeNoise : OpenSimplexNoise

var xNoiseSampleVector:Vector2 = Vector2.RIGHT
var yNoiseSampleVector:Vector2 = Vector2.DOWN

var xNoiseSamplePos:Vector2 = Vector2.ZERO
var yNoiseSamplePos:Vector2 = Vector2.ZERO

var noiseSampleTravelRate:float = 500 #초당 500픽셀
var maxShakeOffset:float = 8 
var currentShakePercentage:float = 0
var shakeDecay:float = 4   #흔들림을 0.25초에 끝낸다.

func _ready():
	#Server for anything visible. The visual server is the API backend for everything visible. The whole scene system mounts on it to display.
	VisualServer.set_default_clear_color(backgroundColor)
	find_player("player")
	
func _process(delta):
	acquire_target_position()

	global_position = lerp(global_position, targetPosition, delta * lerpFactor)
	
#	if Input.is_action_just_pressed("jump"):
#		apply_shake(1)
	
	if currentShakePercentage > 0:
		xNoiseSamplePos += xNoiseSampleVector * noiseSampleTravelRate * delta
		yNoiseSamplePos += yNoiseSampleVector * noiseSampleTravelRate * delta
		var xSample = shakeNoise.get_noise_2d(xNoiseSamplePos.x, xNoiseSamplePos.y)
		var ySample = shakeNoise.get_noise_2d(yNoiseSamplePos.x, yNoiseSamplePos.y)
		
		var calcOffset = Vector2(xSample, ySample) * maxShakeOffset * pow(currentShakePercentage, 2)
		
		self.offset = calcOffset #카메라의 오프셋에 값 넣기
		
		currentShakePercentage = clamp(currentShakePercentage - shakeDecay * delta, 0, 1)
		

func acquire_target_position() :
	
	if is_instance_valid(target) == false :   #g
		if find_player("player") == false : 
			if find_player("player_death") == false:
				#print("시체가 없어요")
				return
	
	targetPosition = target.global_position	

#이건 내가 짠거야. 원래 코드는 process에서 계속 찾음
func find_player(group: String )->bool:
	var targets = get_tree().get_nodes_in_group(group)
	if targets.size() > 0 : 
		target = targets[0];
		return true
	else :
		return false
		
func apply_shake(percentage: float, time:float = 0.25):
	currentShakePercentage = clamp(currentShakePercentage + percentage, 0, 1) #0 ~ 1사이의 퍼센트
	shakeDecay = 1 / time 
	
func resetPlayer():
	find_player("player")
	

extends KinematicBody2D
class_name PlayerGD

signal died

enum State { NORMAL, DASHING }

var gravity = 1000
var velocity = Vector2.ZERO
var maxHorizontalSpeed: float = 125
var minDashSpeed: float = 200
var maxDashSpeed: float = 500
var horizontalAcceleration: float = 1500
var jumpSpeed: float = 350
var jumpTerminateMultiplier: float = 4

var currentState = State.NORMAL

var hasDoubleJump: bool = false  #더블점프 했냐 

var isStateNew: bool = false # 새로운 상태로 전환되었는가?

export(float) var lerpFactor = 1.8

# Called when the node enters the scene tree for the first time.
func _ready():
	$HazardArea2D.connect("area_entered", self, "on_hazard_area_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#스위치 케이스가 이런식이네.....쉣..
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dash(delta)
	
	isStateNew = false
	
func change_state(newState):
	currentState = newState
	isStateNew = true

func process_normal(delta):
	var moveVector = get_movement_vector()
	
	#velocity.x = moveVector.x * maxHorizontalSpeed 
	velocity.x += moveVector.x * horizontalAcceleration * delta
	
	if( moveVector.x == 0):
		velocity.x = lerp(velocity.x, 0, 0.1 * lerpFactor)
		#velocity.x = lerp(0, velocity.x, pow(2, -1 * delta))
	
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if moveVector.y <0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJump) :
		velocity.y = moveVector.y * jumpSpeed
		if !is_on_floor() && $CoyoteTimer.is_stopped() :  #만약 공중에 있는 상태에서 점프를 사용했다면 더블점프를 비활성화 시킨다.
			hasDoubleJump = false
		$CoyoteTimer.stop()  #코요테 시간동안 빠르게 2번 점프가 눌리면 씹히니까 한번 코요테 타임을 사용했다면 비활성화해줘야 한다.
	
	#눌려 있는 동안 올라가고 떼면 바로 내려온다.
	if velocity.y < 0 && Input.is_action_pressed("jump") != true: 
		velocity.y += gravity * jumpTerminateMultiplier * delta
	else:
		velocity.y += gravity * delta
		
	#코요테 타이머란 경계선상에서 떨어질때 점프가 가능하도록 약간의 시간을 더해주는것 
	var wasOnFlor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP) #실제로 이만큼을 이동시키고 난뒤 velocity를 반환하는 매서드
	
	if(wasOnFlor && !is_on_floor()):
		$CoyoteTimer.start()
	
	if(is_on_floor()):
		hasDoubleJump = true
	
	if Input.is_action_just_pressed("dash"):
		#change_state(State.DASHING) 
		call_deferred("change_state", State.DASHING) #모든 작업이 완료되고 idle 타임에 이뤄지도록 call_deferred를 호출
	
	update_animation()

func process_dash(delta):
	if isStateNew :
		velocity = Vector2(maxDashSpeed, 0)	
	
	velocity = move_and_slide(velocity, Vector2.UP)
	#velocity.x = lerp(0, velocity.x, pow(2, -20 * delta)) #거꾸로 lerp방식
	velocity.x = lerp(velocity.x, 0, lerpFactor*2* delta)
	
	if velocity.x < minDashSpeed:
		call_deferred("change_state", State.NORMAL)

func get_movement_vector():
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector
	
func update_animation():
	#내가 만든 GetMove벡터를 이용해서 키보드 입력 값 벡터를 받아온다.
	var moveVec = get_movement_vector()
	
	if(!is_on_floor()):
		$AnimatedPlayerSprite.play("jump")
		#get_node("AnimatedPlayerSprite") 이건 위에 꺼랑 같다.  $를 붙이면 걍 GetComponent 임
	elif (moveVec.x != 0):
		$AnimatedPlayerSprite.play("run")
	else :
		$AnimatedPlayerSprite.play("idle")
	
	if(moveVec.x != 0):
		$AnimatedPlayerSprite.flip_h = true if moveVec.x > 0 else false
		
		
func on_hazard_area_entered(_other_area2d):
	#print("Die")
	emit_signal("died")

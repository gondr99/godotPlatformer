extends KinematicBody2D

var gravity = 1000
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 125
var horizontalAcceleration = 1500
var jumpSpeed = 350
var jumpTerminateMultiplier = 4

var hasDoubleJump = false  #더블점프 했냐 

export(float) var lerpFactor = 1.8

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	
	update_animation()


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
		

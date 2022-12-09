extends KinematicBody2D

class_name EnemySpike

enum Direction { LEFT, RIGHT }
export (Direction) var startDirection

export (float) var maxSpeed: float = 25
var velocity: Vector2 = Vector2.ZERO
var direction: Vector2
var gravity = 1000

#Layer는 해당 물체의 피직스가 어느 레이어 있을 것인가를 체크하는것이고
#Mask는 해당 물체가 어느 레이어에 있는 애랑 충돌을 체크할 것인가 에 대한 문제이다.

func _ready():
	direction = Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT
	$GoalDetector.connect("area_entered", self, "on_goal_entered")

func _process(delta):
	velocity.x = (direction * maxSpeed).x
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
#	if !is_on_floor() : 
	velocity.y += gravity * delta
	
	#방향이 오른쪽이면 가로 플립
	$AnimatedSprite.flip_h = true if direction.x > 0 else false
	
func on_goal_entered(_other):
	direction *= -1 #플립
	

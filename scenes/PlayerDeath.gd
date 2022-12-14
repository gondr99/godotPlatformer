extends KinematicBody2D

var gravity:float = 1000
var velocity: Vector2 = Vector2.ZERO

func _ready():
	if velocity.x > 0:
		$Visuals.scale = Vector2(-1, 1)

func _process(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if(is_on_floor()):
		velocity.x = lerp(velocity.x, 0, 3 * delta)

extends Node2D


func _ready():
	#이벤트 리스너, Area2D에 들어왔을 때 on_area_entered를 실행해준다. self는 context
	$Area2D.connect("area_entered", self, "on_area_entered")

func on_area_entered(area2d):
	print_debug(area2d)
	$AnimationPlayer.play("pickup")
	call_deferred("disable_pickup") #idle 타임에 disable_pickup을 실행해준다. 파라메터 넘길꺼면 뒤에다 , 로 구분해서 넘김
	
	#queue_free() #해당 프레임의 가장 마지막에 삭제된다. (자식들이 모두 안전하게 작업하고 삭제될 수 있도록 )


func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true

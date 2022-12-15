extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	connect("pressed", self, "on_pressed")


func on_mouse_entered():
	$AnimationPlayer.play("hover")
	
func on_mouse_exited():
	#이전 애니메이션이 모두 종료되고 난뒤에 이걸 해줘라.
	#$AnimationPlayer.queue("hover")
	$AnimationPlayer.play_backwards("hover")

func on_pressed():
	$ClickAnimationPlayer.play("click")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_pivot_offset = rect_min_size * 0.5

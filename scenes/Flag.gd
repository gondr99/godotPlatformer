extends Node2D

#승리 시그널
signal player_won

func _ready():
	$Area2D.connect("area_entered", self, "on_area_entered")

func on_area_entered(_other):
	#이녀석이 이 시그널을 쏘면 그걸 아무나 받아서 이벤트 리스닝을 할 수 있다. 
	#아마도 여기선 baseLevel이 해주겠지
	#이런 시그널들은 노드 탭에 시그널을 보면 나온다.
	emit_signal("player_won")

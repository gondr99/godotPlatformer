extends CanvasLayer


func _ready():
	var baseLevels: Array = get_tree().get_nodes_in_group("base_level")
	
	if baseLevels.size() > 0 : 
		(baseLevels[0] as BaseLevel).connect("coin_total_changed", self, "on_coin_total_changed")

#이벤트 받으면 코인 변경
func on_coin_total_changed(total, collected):
	#str은 문자열로 변환하는 함수 string_join임
	$MarginContainer/HBoxContainer/CoinLabel.text = str(collected, "/", total)

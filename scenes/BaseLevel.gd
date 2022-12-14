extends Node
class_name BaseLevel
#코인이 변경되었을 때 
signal coin_total_changed

export(PackedScene) var levelCompleteScene : PackedScene

#프리팹 사전로드
const PlayerScene = preload("res://scenes/Player.tscn")

var spawnPosition :Vector2 = Vector2.ZERO
var currentPlayerNode : PlayerGD = null
var totalCoins:int = 0
var collectedCoins:int = 0;


func _ready():
	spawnPosition = $Player.global_position #시작위치를 스폰 포지션으로 설정
	register_player($Player)
	
	coin_total_changed( get_tree().get_nodes_in_group("coin").size()) 
	#맨처음 코인들을 전부 세서 등록
	
	$Flag.connect("player_won", self, "on_player_won");

func register_player(player):
	currentPlayerNode = player #넘어온 플레이어를 전역변수인 currentPlayerNode에 넣는다.
	currentPlayerNode.connect("died", self, "on_player_died",[], CONNECT_DEFERRED)
	
	#플레이어의 시그널 커넥션, DEFERRED로 하면 시그널은 일단 큐로 들어가고 idle타임에 실행된다.
	
func create_player():
	var playerInstance = PlayerScene.instance()
	#해당 하는 노드의 바로 아래에 놓는다. 노드의 순서가 그려지는 순서라서 
	add_child_below_node(currentPlayerNode, playerInstance)
	playerInstance.global_position = spawnPosition
	register_player(playerInstance)
	
#플레이어 사망시에 실행하게 될 함수
func on_player_died():
	currentPlayerNode.queue_free() #삭제
	create_player()

func coin_collected():
	collectedCoins+= 1
	print(totalCoins, " ", collectedCoins)
	emit_signal("coin_total_changed", totalCoins, collectedCoins)
	
func coin_total_changed(newTotal : int):
	totalCoins = newTotal
	emit_signal("coin_total_changed", totalCoins, collectedCoins)
	
func on_player_won():
	#$"/root/LevelManager".change_level()
	#LevelManager.increment_level()
	currentPlayerNode.queue_free()  #플레이어는 삭제한다. 이렇게 하지 말고 플레이어가 깃발에서 춤추는 게 더 좋을듯
	
	var completeScene = levelCompleteScene.instance()
	add_child(completeScene)
	

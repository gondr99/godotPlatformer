extends Node



#프리팹 사전로드
const PlayerScene = preload("res://scenes/Player.tscn")

var spawnPosition :Vector2 = Vector2.ZERO
var currentPlayerNode : PlayerGD = null

func _ready():
	spawnPosition = $Player.global_position #시작위치를 스폰 포지션으로 설정
	register_player($Player)
	

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

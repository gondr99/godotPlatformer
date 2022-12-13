extends Position2D

enum Direction { LEFT, RIGHT }
export(PackedScene) var enemyScene : PackedScene
export (Direction) var startDirection

var currentEnemyNode: EnemySpike = null #현재 스포닝 된 적이 있는가?
var spawnOnNextTick = false;

func _ready():
	$SpawnTimer.connect("timeout", self, "on_spawn_timer_timeout")
	call_deferred("spawn_enemy") #바로 생성 안되니까 이렇게 
	
func spawn_enemy():
	currentEnemyNode = enemyScene.instance() as EnemySpike
	currentEnemyNode.startDirection = Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT
	#add_child가 들어가면 _ready가 실행된다. 따라서 그전에 넣어야 해
	get_parent().add_child(currentEnemyNode)
	currentEnemyNode.global_position = global_position

func check_enemy_spawn():
	if (!is_instance_valid(currentEnemyNode)):
		#잠시 시간차를 두고 실행될 수 있도록 설계함
		if(spawnOnNextTick):
			spawn_enemy()
			spawnOnNextTick = false
		else:
			spawnOnNextTick = true
		
func on_spawn_timer_timeout():
	check_enemy_spawn()

extends KinematicBody2D

export (int) var speed = 13

onready var ENEMY_BULLET_SCENE = preload("res://Scenes/EnemyBullet.tscn")

var enemyMove = Vector2.ZERO
var enemy
var player = null

const MAX_DISTANCE = 60

func _physics_process(delta):
	enemyMove = Vector2.ZERO
	
	if player != null:
		enemyMove = get_global_position().direction_to(player.get_global_position()) * speed
	else:
		enemyMove = Vector2.ZERO
	
	if player != null:
		var playerDistance = player.position - position
		
		if pow(playerDistance.x, 2) + pow(playerDistance.y, 2) < pow(MAX_DISTANCE, 2):
			enemyMove = Vector2.ZERO
	
	enemyMove = move_and_slide(enemyMove)
	
func _on_Area2D_body_entered(_body):
	if _body == get_parent().get_node("Player"):
		player = _body
		
func _on_Area2D_body_exited(_body):
	if _body == get_parent().get_node("Player"):
		player = null

func fireEnemyBullets():
	var enemyBullet = ENEMY_BULLET_SCENE.instance()
	enemyBullet.position = get_global_position()
	enemyBullet.player = player
	get_parent().add_child(enemyBullet)
	$Timer.set_wait_time(1)

func _on_Timer_timeout():
	if player != null:
		fireEnemyBullets()

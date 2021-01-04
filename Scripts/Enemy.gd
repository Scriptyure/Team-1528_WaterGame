extends KinematicBody2D

export (int) var speed = 1000

onready var ENEMY_BULLET_SCENE = preload("res://Scenes/EnemyBullet.tscn")

var enemyMove = Vector2.ZERO

var enemy
var player = null

func _physics_process(_delta):
	enemyMove = Vector2.ZERO
	
	if player != null:
		enemyMove = position.direction_to(player.position) * speed
	else:
		enemyMove = Vector2.ZERO
	
	enemyMove = enemyMove.normalized()
	enemyMove = move_and_collide(enemyMove)
	
func _on_Area2D_body_entered(_body):
	if _body != self:
		player = _body
		
func _on_Area2D_body_exited(_body):
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

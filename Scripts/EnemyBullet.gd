extends Area2D

var moveBullet = Vector2.ZERO
var lookVector = Vector2.ZERO
var player = null
export (int) var speed = 300

func _ready():
	lookVector = player.position - global_position

func _physics_process(_delta):
	moveBullet = moveBullet.move_toward(lookVector, _delta)
	moveBullet = moveBullet.normalized() * speed
	

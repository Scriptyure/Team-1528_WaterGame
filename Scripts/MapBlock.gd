extends Node2D

class_name MapBlock
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var collider
var collisionShape

# Called when the node enters the scene tree for the first time.
func _init(StartLocation, extentsDefined):
	position = StartLocation
	collider = Area2D.new()
	collisionShape = CollisionShape2D.new()
	collisionShape.shape = RectangleShape2D.new()
	collisionShape.shape.extents = Vector2(extentsDefined)
	add_child(collisionShape)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

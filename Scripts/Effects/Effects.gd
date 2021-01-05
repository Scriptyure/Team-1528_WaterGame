extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var trackedEntity
var effectTimers = [Timer.new()]
var walkEffectScene = preload("res://Scenes/Effects/WalkEffect.tscn")

func _ready():
	for i in effectTimers.size():
		add_child(effectTimers[i])
		effectTimers[i].one_shot = true

# Called when the node enters the scene tree for the first time.
func _init(EntityNode : Node):
	trackedEntity = EntityNode

func DamageEffect():
	pass

func HealEffect():
	pass

func WalkEffect(FeetLocation):
	print(effectTimers[0].time_left)
	if (effectTimers[0].time_left <= 0):
		var temp = walkEffectScene.instance()
		print("passedTimer")
		temp.position = FeetLocation
		get_node("/root/World").add_child(temp)
		effectTimers[0].start(0.5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

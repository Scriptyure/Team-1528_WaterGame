extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var FadeTimer : Timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(FadeTimer)
	FadeTimer.connect("timeout", self, "fade5")
	FadeTimer.start(0.05)

func fade5():
	if(modulate.a <= 0):
		self.queue_free()
	else:
		position = Vector2(position.x, position.y - 1);
		modulate.a = modulate.a-0.05;
		FadeTimer.start(0.05)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

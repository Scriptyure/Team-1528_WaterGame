extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var timeToDeath;
var timer = Timer.new();
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(timer)
	timer.connect("timeout", self, "Death")
	timer.start(timeToDeath)
	
func Death():
	self.queue_free();


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

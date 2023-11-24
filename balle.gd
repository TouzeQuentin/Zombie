extends Node3D

const SPEED = 80.0

@onready var ray = $RayCast3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED) * delta

func _on_area_3d_body_entered(body):
	print(body.get_groups())
	if body.is_in_group("zombies"):
		body.tuer()
		Global.score += 1;
	if body.is_in_group("cibles"):
		body.toucher()
		print("toucher")
	queue_free()

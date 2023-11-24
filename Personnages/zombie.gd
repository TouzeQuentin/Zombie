extends CharacterBody3D

var player = null

var SPEED = 4.0

@export var player_path = "/root/Principale/NavigationRegion3D/Survivant"

@onready var nav_agent = $NavigationAgent3D
@onready var anim = $AnimationPlayer
@onready var son = $AudioStreamPlayer3D
@onready var son2 = $AudioStreamPlayer3D2

var bonus = load("res://Map/Bonus/bonus_vitesse.tscn")
var bonus_bombe = load("res://Map/Bonus/bonus_bombe.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	
var rng = RandomNumberGenerator.new()

func _ready():
	player = get_node(player_path)
	
func _physics_process(delta):
	if Global.bonus["bombe"] == 1:
		Global.score = Global.score + 1
		tuer()
	anim.play("marcher")
	if !son.is_playing() && !son2.is_playing():
		var my_random_number = rng.randi_range(0, 50)
		if my_random_number == 1:
			son.play()
		if my_random_number == 2:
			son2.play()
	
	velocity = Vector3.ZERO
	# Navigation
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), -delta * 10.0)
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	velocity = transform.basis.z * -SPEED

	velocity.y -= 10 * delta
	
	move_and_slide()

func tuer():
	var my_random_number = rng.randi_range(0, 20)
	if my_random_number == 1|| my_random_number == 2:
		var instance = bonus.instantiate()
		instance.position = global_position
		get_parent().add_child(instance)
	if my_random_number == 3 && Global.bonus["bombe"] != 1:
		var instance = bonus_bombe.instantiate()
		instance.position = global_position
		get_parent().add_child(instance)
	queue_free()

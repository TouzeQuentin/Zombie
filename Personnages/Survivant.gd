extends CharacterBody3D

signal fin

var VITESSE_MARCHER = 5.0
var VITESSE_COURIR = 8.0
const JUMP_VELOCITY = 4.5

const SENSITIVITY = 0.003
const BALLES_MAX = 12

var vitesse
var nbBalles = 12
var save = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var balle = load("res://balle.tscn")
var instance

@onready var tete = $Tete
@onready var camera = $Tete/Camera3D
@onready var arme_ray = $Tete/Camera3D/Arme/RayCast3D
@onready var arme_anim = $Tete/Camera3D/Arme/AnimationPlayer
@onready var son_tire = $Tete/Camera3D/Arme/Tirer
@onready var son_recharger = $Tete/Camera3D/Arme/Recharger

@onready var anim_cam = $Tete/Camera3D/AnimationPlayer

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		tete.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_pressed("courir"):
		if Global.bonus["vitesse"] == 0:
			vitesse = VITESSE_COURIR
		else:
			vitesse = VITESSE_COURIR + 5
			
	else:
		if Global.bonus["vitesse"] == 0:
			vitesse = VITESSE_MARCHER
		else:
			vitesse = VITESSE_MARCHER + 5
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (tete.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * vitesse
		velocity.z = direction.z * vitesse
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		
	if Input.is_action_pressed("shoot"):
		if !arme_anim.is_playing() && nbBalles!=0:
			arme_anim.play("tirer")
			son_tire.play()
			instance = balle.instantiate()
			instance.position = arme_ray.global_position
			instance.transform.basis = arme_ray.global_transform.basis
			
			get_parent().add_child(instance)
			nbBalles = nbBalles -1
	
	if Input.is_action_pressed("recharger"):
		if !arme_anim.is_playing() && nbBalles!=BALLES_MAX:
			arme_anim.play("recharger")
			son_recharger.play()
			nbBalles = BALLES_MAX
	
	if Input.is_action_pressed("viser") && !anim_cam.is_playing() && !save:
		anim_cam.play("visée")
		save = true
		
	if  !Input.is_action_pressed("viser") && !anim_cam.is_playing() && save:
		anim_cam.play("normal")
		save = false
	
	Global.balles = nbBalles;
	move_and_slide()


func _on_area_3d_body_entered(body):
	print(body)
	if body.is_in_group("zombies"):
		fin.emit()
		queue_free()
	if body.is_in_group("Bonus"):
		if body.is_in_group("vitesse"):
			Global.bonus["vitesse"] = 10
			body.queue_free()
		if body.is_in_group("bombe"):
			Global.bonus["bombe"] = 1
			body.queue_free()
	if body.is_in_group("helicoptere") && Global.cible == 4:
		Global.victoire = true
		fin.emit()
		

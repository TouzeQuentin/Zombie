extends Node3D

@onready var spawns = $Spawns
@onready var navigation_region = $NavigationRegion3D
@onready var son_bombe = $Son/Bombe
var zombie = load("res://Personnages/zombie.tscn")
var instance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mot = ""
	%LblMid.text = ""
	for n in Global.balles:
		mot = mot +"I "
	
	if mot == "":
		%LblBalles.add_theme_color_override("font_color", Color(1,0,0))
		%LblBalles.text = "RECHARGER"
		%LblMid.add_theme_color_override("font_color", Color(1,0,0))
		%LblMid.text = "RECHARGER"
	else:
		%LblBalles.add_theme_color_override("font_color", Color(1,1,1))
		%LblBalles.text = mot
		
	if Global.bonus["vitesse"] > 9:
		%LblMid.text = "Bonus de vitesse"
	if Global.bonus["bombe"] == 1 || son_bombe.is_playing():
		if !son_bombe.is_playing():
			son_bombe.play()
		%LblMid.text = "Bombe nucléaire"

func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)
	
func _on_zombie_timer_timeout():
	Global.temps += 1
	Global.bonus["bombe"] = 0
	Global.bonus["vitesse"] = Global.bonus["vitesse"] -1
	if Global.bonus["vitesse"] > 0:
		%LblBonus.text = "Vitesse"
	else:
		%LblBonus.text = ""
	%LblTemps.text = "%d:%02d" % [floor( Global.temps/ 60), Global.temps % 60]
	%LblPoint.text = str(Global.score)
	%LblCibles.text = str(Global.cible) + "/4"
	
	var spawn_point = _get_random_child(spawns).global_position
	instance = zombie.instantiate()
	instance.position = spawn_point
	navigation_region.add_child(instance)


func _on_survivant_fin():
	print("fin")
	$ZombieTimer.stop()
	if !Global.victoire:
		get_tree().change_scene_to_file("res://Menus/menu_fin.tscn")
	else:
		get_tree().change_scene_to_file("res://Menus/menu_victoire.tscn")
		
	

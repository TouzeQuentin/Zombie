extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	%LblScore.text = str(Global.score)
	%LblTemps.text = "%d:%02d" % [floor( Global.temps/ 60), Global.temps % 60]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	Global.score = 0
	Global.temps = 0
	Global.balles = 0
	Global.cible = 0
	Global.victoire = false
	Global.bonus = {"vitesse": 0, "bombe": 0}
	get_tree().change_scene_to_file("res://principale.tscn")

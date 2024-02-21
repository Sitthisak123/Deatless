extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_world_fall_out_body_entered(body):
		for group in ["enemy", "player"]:
			if group in body.get_groups():
				body.HP = 0
				break

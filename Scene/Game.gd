extends Node2D

var NightBorneBody2D = preload("res://Character/Enemy/NightBorne/NightBorne_body_2d.tscn")
var Coin2D = preload("res://Items/Coin/coin_2d.tscn")
signal on_dead(groups: Array, pos)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var count_enemy_group = len(get_tree().get_nodes_in_group("enemy"))
	#print($PlayerBody2D.global_position)

	if not count_enemy_group:
		for i in range(3):  # Create 3 unique instances
			var enemy_instance = NightBorneBody2D.instantiate()  # Instantiate a new instance each time
			var rand_pos_x = randi_range(-400, 650)
			while abs(rand_pos_x - $PlayerBody2D.global_position.x) < 20:
				rand_pos_x = randi_range(-400, 650)
			enemy_instance.set_position(Vector2(rand_pos_x, -100))
			enemy_instance.animeStates = 2
			add_child(enemy_instance)

	#print(count_enemy_group)


func _on_on_dead(groups: Array, pos):
	if(groups):
		if("enemy" in groups):
			var Coin2D_ins = Coin2D.instantiate()
			Coin2D_ins.set_position(pos)
			add_child(Coin2D_ins)
		else:
			pass # Replace with function body.

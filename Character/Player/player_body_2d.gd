extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
enum ANIME_STATE {
	attacking,
	jumping,
	climimg,
	running,
	idling,
	idle,
	dead
}
var playerState = ANIME_STATE.idle
var playerPrevState = null
var player_Attak = {}

var origin_gravity = gravity

var maxHP = get_meta("maxHP") if get_meta("maxHP") else 100.0
var HP = get_meta("HP") if get_meta("HP") else 100.0
var ATK = get_meta("ATK") if get_meta("ATK") else 10.0

signal on_player_takeDamage(atk)

func _ready():
	$Control/MarginContainer/ProgressBar.set_value_no_signal(HP/maxHP*100.0)
	

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	
	if(HP > 0):
		if not is_on_floor() and playerState != ANIME_STATE.attacking or playerState != ANIME_STATE.attacking:
			velocity.y += gravity * delta
		#print(Input.is_action_just_pressed("attack - light"))
		if Input.is_action_just_pressed("attack - light"):
			lightAttack()
			pass
		if Input.is_action_just_pressed("attack - heavy"):
			print(ANIME_STATE.keys()[playerState])
			pass
		# Handle jump.
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			playerPrevState = playerState
			playerState = ANIME_STATE.jumping
			$AnimationPlayer.stop()
			$AnimatedSprite2D.play("Player - Jump all")
		if(playerState == ANIME_STATE.attacking):
			velocity.x = 0
			velocity.y = 0
		
		if direction and playerState != ANIME_STATE.attacking:
			velocity.x = direction * SPEED
			playerPrevState = playerState
			playerState = ANIME_STATE.running
			$AnimatedSprite2D.play("Player - Run")
			player_Change_Direction(direction)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if (playerState != ANIME_STATE.attacking):
				if(playerState != ANIME_STATE.jumping):
					playerPrevState = playerState
					playerState = ANIME_STATE.idle
					$AnimatedSprite2D.play("Player - Idle")
			elif(direction):
				#player_Change_Direction(direction)
				pass
			
		
		move_and_slide()
	else:
		playerState = ANIME_STATE.dead
		if($AnimatedSprite2D.animation != "Player - Dead"):
			$AnimatedSprite2D.play("Player - Dead")
	
func lightAttack():
	playerPrevState = playerState
	playerState = ANIME_STATE.attacking
	$AnimatedSprite2D.play("Player - Attack_Light All")
	$AnimationPlayer.play("Attack - 01")
	var direction = Vector2.LEFT if $AnimatedSprite2D.flip_h == true else Vector2.RIGHT
	var forward = direction.x
	$".".position.x = global_position.x + 7 * forward
	player_Attak = {"atk": ATK}
	
func player_Change_Direction(direction):
	if direction < 0:
		$AnimatedSprite2D.flip_h = true
		$Attack_Area/CollisionPolygon2D.scale.x = -1
	else:
		$AnimatedSprite2D.flip_h = false
		$Attack_Area/CollisionPolygon2D.scale.x = 1
	




func _on_animated_sprite_2d_animation_finished():
	
	if(playerState == ANIME_STATE.jumping):
		playerPrevState = playerState
		playerState = ANIME_STATE.idle
		pass
	elif(playerState == ANIME_STATE.attacking):
		playerPrevState = playerState
		playerState = ANIME_STATE.idle
		pass
	elif(playerState == ANIME_STATE.running):
		playerPrevState = playerState
		playerState = ANIME_STATE.idle
		pass
	elif(playerState == ANIME_STATE.dead):
		print("Games Over !!!!")
		$AnimatedSprite2D.pause()
	pass
	


func _on_animated_sprite_2d_frame_changed():
	if playerState == ANIME_STATE.attacking and $AnimatedSprite2D.get_frame() == 4:
		var direction = Vector2.LEFT if $AnimatedSprite2D.flip_h == true else Vector2.RIGHT
		var forward = direction.x
		$".".position.x = (global_position.x + 7 * forward)
		player_Attak = {"atk": ATK}

	#elif(playerState == ANIME_STATE.attacking and $AnimatedSprite2D.get_frame() == )





func _on_attack_area_body_entered(body):
	if "enemy" in body.get_groups():
		#print(" ---Hit--: ", player_Attak["atk"])
		player_attacked(body, player_Attak["atk"])


func _on_on_player_take_damage(enemy_atk):
	HP -= enemy_atk
	$Control/MarginContainer/ProgressBar.set_value(HP/maxHP*100.0)
	print(enemy_atk)
	
func player_attacked(enemy_Node, player_atk):
	enemy_Node.on_enemy_TakeDammage.emit(player_atk)
	

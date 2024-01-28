extends Node

# win condition
var total_keypass_in_level : int
var keypass_found : int
var keypass_flag : bool = false

var total_ennemies_in_level = 0
var enemies_kill : int
var enemies_flag : bool = false

# `pre_start()` is called when a scene is loaded.
# Use this function to receive params from `Game.change_scene(params)`.
func pre_start(params):
	var cur_scene: Node = get_tree().current_scene
	print("Scene loaded: ", cur_scene.name, " (", cur_scene.scene_file_path, ")")
	if params:
		for key in params:
			var val = params[key]
			printt("", key, val)

	# Param initial de la progress bar 
	$GameUi/LaughBar/ProgressBar.value = PlayersInfos.funTimerMaxValue
	$GameUi/LaughBar/ProgressBar.max_value = PlayersInfos.funTimerMaxValue
	$FunTimer.set_wait_time(PlayersInfos.funTimerMaxValue)
	
	# Param win condition
	keypass_found = 0
	enemies_kill = 0
	for child in get_children():
		if child is Ennemy :
			total_ennemies_in_level = total_ennemies_in_level +1
		if child is AccesCard :
			total_keypass_in_level = total_keypass_in_level + 1
			
	print("total_ennemies_in_level : ")
	print(total_ennemies_in_level)
	print("total_keypass_in_level : ")
	print(total_keypass_in_level)

# `start()` is called after pre_start and after the graphic transition ends.
func start():
	$FunTimer.start()
	print("gameplay.gd: start() called")

func increase_enemies_kill():
	enemies_kill = enemies_kill + 1
	if enemies_kill == total_ennemies_in_level :
		enemies_flag = true

func increase_keypass_found():
	keypass_found = keypass_found +1
	if keypass_found == total_keypass_in_level :
		keypass_flag = true

func check_victory_state():
	if enemies_flag && keypass_flag:
		var params = {}
		Game.change_scene_to_file("res://scenes/menu/winScreen.tscn", params)


func _process(delta):
	$GameUi/LaughBar/ProgressBar.value = $FunTimer.get_time_left()
	check_victory_state()
	
	#if $GameUi/LaughBar/Timer.get_time_left() <= 0 :
		#$player.destroyPlayer()
		#print("game over")


func _on_fun_timer_timeout():
	#$player.destroyPlayer()
	print("timeout")
	var params = {}
	Game.change_scene_to_file("res://scenes/menu/GameOver.tscn", params)
	#set_process_input(false)
	#player.set_process_input(false)

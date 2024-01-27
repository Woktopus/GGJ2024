extends Node


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
	$GameUi/LaughBar/ProgressBar.value = 10
	$GameUi/LaughBar/ProgressBar.max_value = 10
	$GameUi/LaughBar/Timer.set_wait_time(10)
	
	#$GameUi/LaughBar/Timer.



# `start()` is called after pre_start and after the graphic transition ends.
func start():
	$GameUi/LaughBar/Timer.start()
	print("gameplay.gd: start() called")


func _process(delta):
	$GameUi/LaughBar/ProgressBar.value = $GameUi/LaughBar/Timer.get_time_left()
	#print(str($GameUi/LaughBar/Timer.get_time_left()))
	#print(str($GameUi/LaughBar/Timer.is_stopped()))
	
	if $GameUi/LaughBar/Timer.get_time_left() <= 0 :
		$player.destroyPlayer()
		print("game over")

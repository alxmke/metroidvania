extends Node

func instance_scene_in_world(scene, position):
	var world = get_tree().current_scene
	var instance = scene.instance()
	instance.global_position = position
	world.add_child(instance)
	return instance

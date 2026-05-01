extends Node3D

var cue_ball_scene = preload("res://cue_ball.tscn")
var cue_ball_start_pos = Vector3(0, 0.009, -0.46)
var is_respawning = false
var respawn_timer = 0.0

func _process(_delta):
	if is_respawning:
		respawn_timer += _delta
		if respawn_timer >= 1.0:
			is_respawning = false
			respawn_timer = 0.0
			var new_cue_ball = cue_ball_scene.instantiate()
			add_child(new_cue_ball)
			new_cue_ball.global_position = cue_ball_start_pos
			new_cue_ball.add_to_group("balls")
		return

	var balls = get_tree().get_nodes_in_group("balls")
	for ball in balls:
		if not is_instance_valid(ball):
			continue
		if not ball.is_inside_tree():
			continue
		if ball.is_queued_for_deletion():
			continue
		var pos = ball.position
		if pos.y < -0.5:
			if ball.name == "CueBall":
				ball.queue_free()
				is_respawning = true
				respawn_timer = 0.0
			else:
				ball.queue_free()

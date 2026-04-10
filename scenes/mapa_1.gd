extends Node2D

var score = 0
var game_time = 0.0

@onready var time_label = %TimeLabel
@onready var score_label = %ScoreLabel
@onready var firefly_scene = preload("res://scenes/svitliaczky.tscn")

func _ready():
	if time_label:
		time_label.text = "Час: 0"
	if score_label:
		score_label.text = "Світлячки: 0"

func _process(delta):
	game_time += delta
	if time_label:
		time_label.text = "Час: " + str(int(game_time))

func add_score():
	score += 1
	if score_label:
		score_label.text = "Світлячки: " + str(score)

func _on_timer_timeout():
	var current_fireflies = get_tree().get_nodes_in_group("fireflies").size()
	
	if current_fireflies < 20:
		var points = find_children("*", "Marker2D") 
		if points.size() > 0:
			var random_point = points[randi() % points.size()]
			
			var new_firefly = firefly_scene.instantiate()
			new_firefly.global_position = random_point.global_position
			new_firefly.add_to_group("fireflies")
			add_child(new_firefly)

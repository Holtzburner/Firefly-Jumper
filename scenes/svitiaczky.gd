extends Area2D

func _ready():
	$AnimatedSprite2D.play("Caught")

func _on_body_entered(body):
	if body.name == "Player":
		
		var parent = get_parent()
		if parent.has_method("add_score"):
			parent.add_score()
		
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.play("Fly")
		
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "Fly":
		queue_free()

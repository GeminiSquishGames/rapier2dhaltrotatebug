extends RigidBody2D


func _on_ttl_timer_timeout() -> void:
   queue_free()

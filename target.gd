class_name Target
extends RigidBody2D


func _ready() -> void:
    modulate = Color(randf(),randf(),randf())


func _physics_process(delta: float) -> void:
    #apply_torque(10000)
    pass

func _on_body_entered(body: Node) -> void:
    pass

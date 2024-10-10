extends Sprite2D

@export var texnoise : FastNoiseLite


func _process(delta: float) -> void:
    texnoise.offset.z += 4 * delta

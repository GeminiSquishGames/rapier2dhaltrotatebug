extends RigidBody2D

@export var pew_scene : PackedScene

@export var impulse_mag : float = 50000 * mass
@export var torque_mag : float = 8000000 * mass
@export var pew_impulse_mag : float = 10000 * mass

var pew_instance
var pew_mag_mod : float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass


func _physics_process(delta: float) -> void:

    if Input.is_action_pressed("forward"):
        apply_central_force(Vector2.from_angle(global_rotation) * impulse_mag * delta)
    if Input.is_action_pressed("backward"):
        apply_central_force(Vector2.from_angle(global_rotation) * -impulse_mag * delta)
    if Input.is_action_pressed("break"):
        linear_damp = 5.0
        angular_damp = 5.0
        pew_mag_mod = 0.1
        #$"../Target".linear_damp = 1000.0
    else:
        linear_damp = 0.0
        angular_damp = 0.0
        pew_mag_mod = 1.0
        #$"../Target".linear_damp = 0.0

# mouse turn
    # disable if using controller or keyboard turning
    mouse_rotation_control()

    if Input.is_action_pressed("pew") and $FireSpeed.time_left <= 0.0:
        pew_instance = pew_scene.instantiate()
        $FireSpeed.start()
        pew_instance.global_position = global_position
        pew_instance.mass = 10.0 * $"../CanvasLayer/HSlider2".value
        var pew_impulse = Vector2.from_angle(global_rotation) * pew_impulse_mag * pew_mag_mod * delta * $"../CanvasLayer/HSlider".value
        get_node("/root").add_child(pew_instance)
        pew_instance.apply_impulse(pew_impulse)
        $"../CanvasLayer/Label".text = "Pew Magnitude multiplier, pew velocity = " + str(pew_impulse)
        $"../CanvasLayer/Label2".text = "Pew weight multiplier, mass = " + str(pew_instance.mass)


# for controller or keyboard turning
    #if Input.is_action_pressed("turn CW"):
        #apply_torque(torque_mag * d)
    #if Input.is_action_pressed("turn CCW"):
        #apply_torque(-torque_mag * d)


func mouse_rotation_control():
    var glr = global_rotation
    var to_rotation
    #to_rotation = glr + get_angle_to(get_global_mouse_position())
    to_rotation = lerp_angle(glr, glr + get_angle_to(get_global_mouse_position()) , 5.0 * get_physics_process_delta_time())
    # low precision mode: gives it some wobble
    var rot_factor = glr - to_rotation
    apply_torque(-torque_mag * rot_factor * get_physics_process_delta_time())

    # High precision mode: snappier, but collision calc will be fuxxorz
    # global_rotation = to_rotation

extends RigidBody3D

var rng = RandomNumberGenerator.new()

@onready var Ball = self 
@onready var ball_mesh = get_node("BallObject")
@onready var offhand = get_node("../player/XROrigin3D/offhand")
@onready var hand_marker = get_node("../player/XROrigin3D/offhand/MeshInstance3D")
@onready var bat = get_node("../player/XROrigin3D/Main hand/Paddle")
@onready var scene = get_node("..")

@export var maxSpeed = 1

var frozen = false
var teleporting = false
var telePosition
var prev_hand_pos
var AllowedToHitBat = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Grabbing
	if !frozen and offhand.get_input("trigger") == 1 and (ball_mesh.global_position - hand_marker.global_position).length() < 0.06:
		
		Ball.set_freeze_enabled(true)
		Ball.reparent(offhand)
		frozen = true
		
	elif frozen and not offhand.get_input("trigger") == 1:
		
		linear_velocity = (hand_marker.global_position - prev_hand_pos) / delta
		Ball.set_freeze_enabled(false)
		Ball.reparent(scene)
		frozen = false
		
	else:
		pass
		
	prev_hand_pos = hand_marker.global_position
	
	runSpin(delta)
	capVelocity()
	
func launch(launchPos, launchVel, launchSpin):
	telePosition = launchPos
	linear_velocity = launchVel
	angular_velocity = launchSpin
	teleporting = true
	
func capVelocity():
	if linear_velocity.length() > maxSpeed:
		linear_velocity = linear_velocity.normalized() * maxSpeed
	
func runSpin(deltatime):
	var spinForce = angular_velocity.cross(linear_velocity) * (deltatime / max(angular_velocity.length(),1))
	linear_velocity += spinForce
	
func serve():
	var servePos = Vector3(-2 + rng.randf_range(-0.1,0.1), 1.1 + rng.randf_range(-0.1,0.1),0.65 + rng.randf_range(-0.1,0.1))
	var serveVel = 2 * Vector3(2.1 + rng.randf_range(-0.4,0.4), 0.5 + rng.randf_range(-0.15,0.1), -0.6 + rng.randf_range(-0.1,0.1))
	var serveSpin = Vector3(rng.randf_range(-90,90),rng.randf_range(-90,90),-rng.randf_range(60,200))
	launch(servePos, serveVel, serveSpin)

func _on_offhand_button_pressed(name):
	print(name)
	match name:
		"grip_click":
			serve()
		"trigger_click":
			telePosition = offhand.global_position
			linear_velocity = Vector3(0,0,0)
			angular_velocity = Vector3(0,0,0)
			teleporting = true
		
func _integrate_forces(state):
	if teleporting:
		
		var trnsfrm = state.get_transform()
		
		trnsfrm.origin.x = telePosition.x
		trnsfrm.origin.y = telePosition.y
		trnsfrm.origin.z = telePosition.z
		
		teleporting = false
		
		state.set_transform(trnsfrm)


func _on_body_entered(body):
	if body == bat:
		if AllowedToHitBat:
			print("Hit")
			AllowedToHitBat = false
			linear_velocity /= 3
	else:
		AllowedToHitBat = true

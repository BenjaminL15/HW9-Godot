extends CharacterBody2D
var gravity : Vector2
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity = Vector2(0, 100)
	pass # Replace with function body.


func _get_input():
	# Basically if Godot bot is on the floor we can freely move around based on the movement speed 
	if is_on_floor():
		# If we press "a" on the keyboard which is the input for moving left we are able to move to the left
		if Input.is_action_pressed("move_left"):
			# This is decreasing our velocity from the object by the movement speed because it is going the opposite direction
			velocity += Vector2(-movement_speed,0)
		# If we press "d" on the keyboard which is the input for moving right we are able to move to the right
		if Input.is_action_pressed("move_right"):
			# This is adding to our velocity based on the movement speed, but there is no negative sign 
			# because we are not going the opposite direction.
			velocity += Vector2(movement_speed,0)
		# If we press the spacebar which is the input for jump, we will be in the air 
		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			# The negative jump_height meanst that we are going upward as we are going up the screen 
			velocity += Vector2(1,-jump_height)
	# basically saying if we are in the air 
	if not is_on_floor():
		# If we press "a" on the keyboard which is the input for moving left we are able to move to the left
		if Input.is_action_pressed("move_left"):
			# If we are in the air, we would include the negative movement speed but also will be affected
			# by the horizontal air coefficient which represents how fast we are able to move while in the air 
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0)
		# If we press "d" on the keyboard which is the input for moving right we are able to move to the right
		if Input.is_action_pressed("move_right"):
			# If we are in the air, we would include the movement speed but also will be affected
			# by the horizontal air coefficient which represents how fast we are able to move while in the air 
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)

func _limit_speed():
	# if our x velocity exceeds the given speed limit it will call the next statement 
	if velocity.x > speed_limit:
		# THis will set the horizontal movement to the speed limit and the leave the y componenet unchanged 
		velocity = Vector2(speed_limit, velocity.y)
	# This is for the opposite direction 
	if velocity.x < -speed_limit:
		# It will do the same for the opposite 
		velocity = Vector2(-speed_limit, velocity.y)

func _apply_friction():
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		velocity -= Vector2(velocity.x * friction, 0)
		if abs(velocity.x) < 5:
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero

# Gravity purposes, meaning we need gravity for when we jump 
func _apply_gravity():
	# when not on the floor but in the air 
	if not is_on_floor():
		# we are adding gravity to velocity so we are not floating in the air but falling 
		velocity += gravity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_get_input()
	_limit_speed()
	_apply_friction()
	_apply_gravity()

	move_and_slide()
	pass

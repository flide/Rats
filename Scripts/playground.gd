extends Node2D

onready var snake = $snake
export var foodScene: PackedScene
var food
var randomNumberGenerator: RandomNumberGenerator = RandomNumberGenerator.new()
var screen_size: Vector2
var window_size: Vector2

func _ready():
	screen_size = OS.get_screen_size()
	window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)

	setupEgg()

func snake_found_egg(body):
	food.queue_free()
	snake.food_eaten()
	setupEgg()

func setupEgg():
	randomNumberGenerator.randomize()
	var foodPosition = Vector2(randomNumberGenerator.randf_range(0.0, window_size.x), randomNumberGenerator.randf_range(0.0, window_size.y))
	food = foodScene.instance()
	food.set_position(foodPosition)
	food.connect("body_entered", self, "snake_found_egg")
	add_child(food)


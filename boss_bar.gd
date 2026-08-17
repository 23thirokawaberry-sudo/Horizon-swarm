extends ProgressBar

@onready var boss = get_parent()

func _ready():
	scale = Vector2.ONE / boss.scale
	max_value = boss.max_health
	value = boss.health

func _process(delta):
	value = boss.health

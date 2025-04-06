class_name Util

static func collide_rect(r: Rect2, p: Vector2):
	return p.x >= r.position.x && p.y >= r.position.y && p.x <= r.position.x + r.size.x && p.y <= r.position.y + r.size.y


static func screen_to_world(viewport: Viewport, screen_point: Vector2):
	var transformer = viewport.get_canvas_transform().affine_inverse()
	return (screen_point * transformer.get_scale()[0] + transformer.origin)

static func number_to_human(n: float) -> String:
	var unit = ""
	if n > 1_000_000_000_000_000_000_000_000_000_000.0:
		n = n / 1_000_000_000_000_000_000_000_000_000_000.0
		unit = "Q"
	elif n > 1_000_000_000_000_000_000_000_000_000.0:
		n = n / 1_000_000_000_000_000_000_000_000_000.0
		unit = "R"
	elif n > 1_000_000_000_000_000_000_000_000.0:
		n = n / 1_000_000_000_000_000_000_000_000.0
		unit = "Y"
	elif n > 1_000_000_000_000_000_000_000.0:
		n = n / 1_000_000_000_000_000_000_000.0
		unit = "Z"
	elif n > 1_000_000_000_000_000_000.0:
		n = n / 1_000_000_000_000_000_000.0
		unit = "E"
	elif n > 1_000_000_000_000_000.0:
		n = n / 1_000_000_000_000_000.0
		unit = "P"
	elif n > 1_000_000_000_000.0:
		n = n / 1_000_000_000_000.0
		unit = "T"
	elif n > 1_000_000_000.0:
		n = n / 1_000_000_000.0
		unit = "G"
	elif n > 1_000_000.0:
		n = n / 1_000_000
		unit = "M"
	elif n > 1_000:
		n = n / 1000
		unit = "k"

	n = round(n * 100) / 100
	
	return str(n) + unit

static func factorial(n: int) -> float:
	if n == 0: return 1.0
	return n * factorial(n - 1)

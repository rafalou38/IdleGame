class_name Util

static func screen_to_world(viewport: Viewport, screen_point: Vector2):
	var transformer = viewport.get_canvas_transform().affine_inverse()
	return (screen_point * transformer.get_scale()[0] + transformer.origin)

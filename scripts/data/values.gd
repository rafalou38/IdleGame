class_name Values

static func mine_speed_duration(level: int) -> float:
	return 2.0 / (1 + pow(level, 0.85) * 0.15)
static func process_speed_duration(level: int) -> float:
	return 1.5 / (1 + pow(level, 0.85) * 0.15)

static func process_value_increase(level: int) -> float:
	return 0.1 * level

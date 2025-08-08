class_name Values

static func mine_speed_duration(level: int) -> float:
	return 2.0 / (1 + pow(level + 1, 0.85) * 0.15)
static func process_speed_duration(level: int) -> float:
	return 1.5 / (1 + pow(level + 1, 0.85) * 0.15)
static func refinery_speed_duration(level: int) -> float:
	return process_speed_duration(level) + 0.2 

	# \frac{1.5}{\left(\left(1+x^{0.85}\right)0.15\right)}
static func process_value_increase(level: int) -> float:
	return 0.1 * pow(level + 1,1.6)

static func refinery_value(level: int) -> float:
	return 1 + 0.06 * pow(level + 2, 1.4)

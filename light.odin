package gfx

import "core:math"

Point_Light :: struct {
	position:  Vec3,
	intensity: Real,
}

Direction_Light :: struct {
	direction: Vec3,
	intensity: Real,
}

Ambient_Light :: struct {
	intensity: Real,
}

Light_Source :: union {
	Point_Light,
	Ambient_Light,
	Direction_Light,
}

apply_light :: proc(c: Color, lum: Real) -> Color {
	r, g, b, a := rgba_from_col_real(c)
	lr := clamp(Real(0), r * lum, 1.0)
	lg := clamp(Real(0), g * lum, 1.0)
	lb := clamp(Real(0), b * lum, 1.0)
	return col_from_rgba(lr, lg, lb, a)
}

@(private = "file")
compute_diffuse_light_intensity :: proc(
	point: Vec3,
	normal: Vec3,
	direction: Vec3,
	intensity: Real,
) -> Real {
	prod := dot_product(normal, direction)
	if prod > 0 {
		return intensity * prod / (mag(normal) * mag(direction))
	}
	return 0
}

compute_diffuse_light :: proc(point: Vec3, normal: Vec3, sources: []Light_Source) -> Real {
	lum: Real

	for source in sources {
		switch light in source {
		case Ambient_Light:
			lum += light.intensity
		case Point_Light:
			{
				direction := light.position - point
				lum += compute_diffuse_light_intensity(point, normal, direction, light.intensity)
			}
		case Direction_Light:
			lum += compute_diffuse_light_intensity(point, normal, light.direction, light.intensity)
		}
	}

	return lum
}

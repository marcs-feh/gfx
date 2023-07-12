package gfx

import "core:math"

@(private = "file")
PRECISION_BITS :: 32

Vec2 :: [2]Real
Vec3 :: [3]Real
Vec4 :: [4]Real

Vec2i :: [2]int
Vec3i :: [3]int
Vec4i :: [4]int

Sphere :: struct {
	origin: Vec3,
	radius: Real,
	color:  Color,
}

when PRECISION_BITS == 64 {
	Real :: f64
	Complex :: complex128
	Quaternion :: quaternion256
} else when PRECISION_BITS == 32 {
	Real :: f32
	Complex :: complex64
	Quaternion :: quaternion128
} else when PRECISION_BITS == 16 {
	Real :: f16
	Complex :: complex32
	Quaternion :: quaternion64
} else {
	#assert(false, "PRECISION_BITS must be either: 16, 32, 64")
}

solve_quadratic :: proc(a, b, c: $T) -> Maybe([2]T) {
	if a == 0 {return nil}
	delta := (b * b) - (4 * a * c)
	if delta < 0 {return nil}

	s0 := ((-b) + math.sqrt(delta)) / (2 * a)
	s1 := ((-b) - math.sqrt(delta)) / (2 * a)

	return [2]Real{s0, s1}
}

mag :: proc {
	mag_v2,
	mag_v3,
	mag_v4,
}
distance :: proc {
	distance_v2,
	distance_v3,
	distance_v4,
}
dot_product :: proc {
	dot_product_v2,
	dot_product_v3,
	dot_product_v4,
}

clamp :: proc(floor, x, ceil: $T) -> T {
	switch true {
	case x < floor:
		return floor
	case x > ceil:
		return ceil
	}
	return x
}

between :: proc(floor, x, ceil: $T) -> bool {
	return (x <= ceil) && (x >= floor)
}

// where sp is a point on the surface of the sphere
sphere_normal :: proc(sphere: Sphere, sp: Vec3) -> Vec3 {
	return (sp - sphere.origin) / (mag(sp) - mag(sphere.origin))
}

mag_v2 :: proc(v: Vec2) -> Real {
	sq := v * v
	return math.sqrt(sq.x + sq.y)
}

mag_v3 :: proc(v: Vec3) -> Real {
	sq := v * v
	return math.sqrt(sq.x + sq.y + sq.z)
}

mag_v4 :: proc(v: Vec4) -> Real {
	sq := v * v
	return math.sqrt(sq.x + sq.y + sq.z + sq.w)
}

dot_product_v2 :: proc(a, b: Vec2) -> Real {
	p := a * b
	return p.x + p.y
}

dot_product_v3 :: proc(a, b: Vec3) -> Real {
	p := a * b
	return p.x + p.y + p.z
}

dot_product_v4 :: proc(a, b: Vec4) -> Real {
	p := a * b
	return p.x + p.y + p.z + p.w
}

distance_v2 :: proc(a, b: Vec2) -> Real {
	return mag(a - b)
}

distance_v3 :: proc(a, b: Vec3) -> Real {
	return mag(a - b)
}

distance_v4 :: proc(a, b: Vec4) -> Real {
	return mag(a - b)
}

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
	o: Vec3,
	r: Real,
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

mag :: proc { mag_v2, mag_v3, mag_v4 }
distance :: proc{ distance_v2, distance_v3, distance_v4 }

mag_v2 :: proc(v: Vec2) -> Real{
	sq := v * v
	return math.sqrt(sq.x + sq.y)
}

mag_v3 :: proc(v: Vec3) -> Real{
	sq := v * v
	return math.sqrt(sq.x + sq.y + sq.z)
}

mag_v4 :: proc(v: Vec4) -> Real{
	sq := v * v
	return math.sqrt(sq.x + sq.y + sq.z + sq.w)
}

distance_v2 :: proc(a, b:Vec2) -> Real {
	return mag(a-b)
}

distance_v3 :: proc(a, b:Vec3) -> Real {
	return mag(a-b)
}

distance_v4 :: proc(a, b:Vec4) -> Real {
	return mag(a-b)
}


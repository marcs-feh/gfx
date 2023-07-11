package gfx

@(private="file")
PRECISION_BITS :: 16

Vec2 :: [2]Real
Vec3 :: [3]Real
Vec4 :: [4]Real

Vec2i :: [2]int
Vec3i :: [3]int
Vec4i :: [4]int

when PRECISION_BITS == 64 {
	Real :: f64
	Complex :: complex128
	Quaternion :: quaternion256
}
else when PRECISION_BITS == 32 {
	Real :: f32
	Complex :: complex64
	Quaternion :: quaternion128
}
else when PRECISION_BITS == 16 {
	Real :: f16
	Complex :: complex32
	Quaternion :: quaternion64
}
else {
	#assert(false, "PRECISION_BITS must be either: 16, 32, 64")
}

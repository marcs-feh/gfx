package gfx

import "core:math"

Color :: u32

Canvas :: struct {
	pixels: []Color,
	height: int,
	width:  int,
}

rgba_from_col :: proc(c: Color) -> (r, g, b, a: u8) {
	r = u8((c & 0xff000000) >> 24)
	g = u8((c & 0x00ff0000) >> 16)
	b = u8((c & 0x0000ff00) >> 8)
	a = u8(c & 0x000000ff)
	return
}

rgba_from_col_real :: proc(c: Color) -> (r, g, b, a: Real) {
	ri := u8((c & 0xff000000) >> 24)
	gi := u8((c & 0x00ff0000) >> 16)
	bi := u8((c & 0x0000ff00) >> 8)
	ai := u8(c & 0x000000ff)

	r = Real(ri) / 255
	g = Real(gi) / 255
	b = Real(bi) / 255
	a = Real(ai) / 255

	return
}

col_from_rgba :: proc {
	col_from_rgba_u8,
	col_from_rgba_real,
}

col_from_rgba_real :: proc(r, g, b: Real, a: Real = 1.0) -> Color {
	r_s := r * 255
	g_s := g * 255
	b_s := b * 255
	a_s := a * 255

	return col_from_rgba_u8(
		auto_cast math.trunc(r_s),
		auto_cast math.trunc(g_s),
		auto_cast math.trunc(b_s),
		auto_cast math.trunc(a_s),
	)


}

col_from_rgba_u8 :: proc(r, g, b: u8, a: u8 = 0xff) -> Color {
	c: Color = (u32(r) << 24) | (u32(g) << 16) | (u32(b) << 8) | u32(a)
	return c
}

canvas_make :: proc(width, height: int) -> Canvas {
	cv := Canvas {
		height = height,
		width  = width,
		pixels = make([]Color, width * height),
	}
	return cv
}

canvas_destroy :: proc(using cv: ^Canvas) {
	delete(pixels)
	cv^ = Canvas{}
}

canvas_clear :: proc(using cv: ^Canvas) {
	ptr := transmute([^]int)raw_data(pixels)
	n, rest := div_rem(len(pixels) * size_of(Color), size_of(uintptr))
	black :: 0x000000ff

	for i := 0; i < n; i += 1 {ptr[i] = black}
	for i := 0; i < rest; i += 1 {pixels[i] = black}
}

screen_to_canvas_coord :: proc(using cv: ^Canvas, sx, sy: int, scale: f32 = 1) -> (int, int) {
	sx: int = auto_cast (f32(sx) / scale)
	sy: int = auto_cast (f32(sy) / scale)
	x := sx - (width / 2)
	y := (height / 2) - sy

	return x, y
}

@(private = "file")
div_rem :: proc(a, b: int) -> (int, int) {
	div := a / b
	mod := a % b
	return div, mod
}

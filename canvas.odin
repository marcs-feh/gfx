package gfx

Color :: u32

rgba_from_col :: proc(c: Color) -> (r,g,b,a:u8) {
	r = u8((c & 0xff000000) >> 24)
	g = u8((c & 0x00ff0000) >> 16)
	b = u8((c & 0x0000ff00) >> 8)
	a = u8(c & 0x000000ff)
	return
}


col_from_rgba :: proc(r,g,b:u8, a: u8=0xff) -> Color {
	c: Color = (u32(r) << 24) | (u32(g) << 16) | (u32(b) << 8) | u32(a)
	return c
}

Canvas :: struct {
	pixels: []Color,
	height: uint,
	width: uint,
}

canvas_make :: proc(width, height: uint) -> Canvas {
	cv := Canvas {
		height = height,
		width = width,
		pixels = make([]Color, width * height),
	}
	return cv
}

canvas_destroy :: proc(using cv: ^Canvas){
	delete(pixels)
	cv^ = Canvas{}
}

canvas_clear :: proc(using cv: ^Canvas){
	ptr := transmute([^]int)raw_data(pixels)
	n, rest := div_rem(len(pixels) * size_of(Color), size_of(uintptr))
	black :: 0x000000ff

	for i := 0; i < n; i += 1 { ptr[i] = black }
	for i := 0; i < rest; i += 1 { pixels[i] = black }
}

@(private="file")
div_rem :: proc (a, b: int) -> (int, int) {
	div := a / b
	mod := a % b
	return div, mod
}


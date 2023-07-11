package gfx


@(private = "file")
in_between :: proc(floor, x, ceil: $T) -> bool {
	return (x >= floor) && (x <= ceil)
}

put_pixel :: proc(using cv: ^Canvas, x, y: int, col: Color) {
	if !(in_between(-(width / 2) + 1, x, (width / 2) - 1) &&
		   in_between(-(height / 2) + 1, y, (height / 2) - 1)) {
		return
	}
	sx, sy := screen_to_canvas_coord(cv, x, y)
	cv.pixels[sx + (sy * width)] = col
}

draw_point :: proc(cv: ^Canvas, p: Vec2i, col: Color) {
	put_pixel(cv, p.x, p.y, col)
}

draw_line :: proc(cv: ^Canvas, pa, pb: Vec2i, col: Color) {
	x0, x1 := pa.x, pb.x
	y0, y1 := pa.y, pb.y

	dx := abs(x1 - x0)
	sx := 1 if x0 < x1 else -1

	dy := -abs(y1 - y0)
	sy := 1 if y0 < y1 else -1

	err := dx + dy

	for {
		put_pixel(cv, x0, y0, col)
		if (x0 == x1) && (y0 == y1) {break}

		e := err * 2
		if e >= dy {
			if x0 == x1 {break}
			err += dy
			x0 += sx
		}
		if e <= dx {
			if y0 == y1 {break}
			err += dx
			y0 += sy
		}
	}
}

package gfx

Camera :: struct {
	position:    Vec3,
	vp_width:    Real,
	vp_height:   Real,
	vp_distance: Real,
	view_distance: Real,
}

canvas_to_viewport :: proc(cam: Camera, canvas: Canvas, canvas_coord: Vec2i) -> Vec3 {
	v := Vec3{}
	c := Vec2{auto_cast canvas_coord.x, auto_cast canvas_coord.y}

	v.x = c.x * (cam.vp_width / auto_cast canvas.width)
	v.y = c.y * (cam.vp_height / auto_cast canvas.height)

	return v
}

ray_equation :: proc(origin: Vec3, vp_point: Vec3, t: Real) -> Vec3 {
	d := vp_point - origin
	p := origin + (t * d)
	return p
}

trace_ray :: proc(cam: Camera, dir: Vec3, t_min, t_max: Real) -> Color {
	return col_from_rgba(100, 100, 100)
}

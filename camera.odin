package gfx
import "core:fmt"

Camera :: struct {
	position:      Vec3,
	vp_width:      Real,
	vp_height:     Real,
	vp_distance:   Real,
	view_distance: Real,
}

canvas_to_viewport :: proc(cam: Camera, canvas: Canvas, canvas_coord: Vec2i) -> Vec3 {
	v := Vec3{}
	c := Vec2{auto_cast canvas_coord.x, auto_cast canvas_coord.y}

	v.x = c.x * (cam.vp_width / auto_cast canvas.width)
	v.y = c.y * (cam.vp_height / auto_cast canvas.height)
	v.z = cam.vp_distance

	return v
}

ray_equation :: proc(origin: Vec3, vp_point: Vec3, t: Real) -> Vec3 {
	d := vp_point - origin
	p := origin + (t * d)
	return p
}

ray_sphere_intersect :: proc(cam: Camera, direction: Vec3, sphere: Sphere) -> (t0, t1: Real) {
	d := direction
	r := sphere.radius
	origin := cam.position

	t0 = cam.view_distance + 1
	t1 = t0

	c0 := origin - sphere.origin

	{
		a := dot_product(d, d)
		b := 2 * dot_product(c0, d)
		c := dot_product(c0, c0) - (r * r)
		ans := solve_quadratic(a, b, c)
		if ans != nil {
			t0 = (ans.?).x
			t1 = (ans.?).y
		}
	}

	return
}


trace_ray :: proc(cam: Camera, scene: Scene, dir: Vec3, t_min, t_max: Real) -> Color {
	closest_t := cam.view_distance + 1
	closest_sphere: ^Sphere

	for &sphere in scene.spheres {
		t0, t1 := ray_sphere_intersect(cam, dir, sphere)
		if between(t_min, t0, t_max) && (t0 < closest_t) {
			closest_t = t0
			closest_sphere = &sphere
		}
		if between(t_min, t1, t_max) && (t1 < closest_t) {
			closest_t = t1
			closest_sphere = &sphere
		}
	}

	if closest_sphere == nil {
		return scene.background
	}

	// return closest_sphere.color
	intersection := cam.position + (closest_t * dir)
	normal := sphere_normal(closest_sphere^, intersection)
	lum := compute_diffuse_light(intersection, normal, scene.lights[:])
	return apply_light(closest_sphere.color, lum)
}
